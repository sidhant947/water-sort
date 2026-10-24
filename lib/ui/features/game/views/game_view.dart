import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watersort/domain/use_cases/level_solver.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/core/widgets/tangible_button.dart';
import 'package:watersort/ui/features/game/view_models/game_view_model.dart';
import 'package:watersort/ui/providers.dart';
import 'package:watersort/ui/features/game/views/water_sort_game.dart';

class GameView extends ConsumerStatefulWidget {
  const GameView({
    super.key,
    required this.levelNumber,
    this.isRandom = false,
    this.randomDifficulty = 'Easy',
    this.randomColorCount,
    this.randomCapacity,
    this.randomSeed,
  });

  final int levelNumber;
  final bool isRandom;
  final String randomDifficulty;
  final int? randomColorCount;
  final int? randomCapacity;
  final int? randomSeed;

  @override
  ConsumerState<GameView> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<GameView> {
  WaterSortGame? _game;
  Timer? _hudSwitchTimer;
  bool _showTimerInHud = false;
  final GlobalKey<TooltipState> _solvabilityTooltipKey = GlobalKey<TooltipState>();
  String _solvabilityTooltipMessage = 'Level is solvable';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.isRandom) {
        ref
            .read(gameViewModelProvider.notifier)
            .loadRandomLevel(
              widget.randomDifficulty,
              colorCount: widget.randomColorCount,
              capacity: widget.randomCapacity,
              seed: widget.randomSeed,
            );
      } else {
        ref.read(gameViewModelProvider.notifier).loadLevel(widget.levelNumber);
      }
    });
    _hudSwitchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _showTimerInHud = !_showTimerInHud;
        });
      }
    });
  }

  @override
  void dispose() {
    _hudSwitchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameViewModelProvider);
    if (state.level != null) {
      if (_game == null) {
        _game = WaterSortGame(
          initialState: state,
          onTubeTap: (index) {
            ref.read(gameViewModelProvider.notifier).selectTube(index);
          },
          onPourComplete: () {
            ref.read(gameViewModelProvider.notifier).completePendingPour();
          },
        );
      } else {
        _game!.updateState(state);
      }
    }

    ref.listen<GameViewModelState>(gameViewModelProvider, (prev, next) {
      if (next.isComplete && !(prev?.isComplete ?? false)) {
        if (!next.isInstantPouringEnabled) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            final currentState = ref.read(gameViewModelProvider);
            if (!currentState.isComplete) return;
            if (currentState.isSoundEffectsEnabled) {
              try {
                FlameAudio.play('level_complete.mp3');
              } catch (_) {}
            }
            _showCompleteDialog();
          });
        } else {
          _showCompleteDialog();
        }
      }
      if (next.isTimeOut && !(prev?.isTimeOut ?? false)) {
        _showTimeOutDialog();
      }
    });

    final bool hasCustomBg = state.customBackgroundImagePath != null &&
        File(state.customBackgroundImagePath!).existsSync();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: hasCustomBg
            ? BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(state.customBackgroundImagePath!)),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.3),
                    BlendMode.darken,
                  ),
                ),
              )
            : null,
        child: SafeArea(
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E24).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF2E2E3A),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: (state.timeLeft != null && (state.isRandomMode || _showTimerInHud))
                              ? Row(
                                  key: const ValueKey('timer'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: (state.timeLeft! <= 15
                                                ? Colors.redAccent
                                                : AppColors.accent)
                                            .withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.timer_rounded,
                                        size: 14,
                                        color: state.timeLeft! <= 15
                                            ? Colors.redAccent
                                            : AppColors.accent,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatTime(state.timeLeft!),
                                      style: TextStyle(
                                        fontFamily: 'BebasNeue',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: state.timeLeft! <= 15
                                            ? Colors.redAccent
                                            : AppColors.headingWhite,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  key: const ValueKey('level'),
                                  state.isRandomMode ? 'RANDOM' : 'LEVEL ${widget.levelNumber}',
                                  style: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: !state.isRandomMode && widget.levelNumber % 10 == 0
                                        ? Colors.redAccent
                                        : !state.isRandomMode && widget.levelNumber % 5 == 0
                                        ? Colors.amber
                                        : AppColors.headingWhite,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showRestartConfirmationDialog,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.refresh_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(gameViewModelProvider.notifier)
                                .resetLevel(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _buildGame(state),
            ),
            _buildBottomBar(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(GameViewModelState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E24).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF2E2E3A),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: state.canUndo
                  ? () => ref
                        .read(gameViewModelProvider.notifier)
                        .undoMove()
                  : null,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.undo_rounded,
                      size: 18,
                      color: state.canUndo
                          ? AppColors.accent
                          : AppColors.subtext.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'UNDO',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: state.canUndo
                            ? AppColors.accent
                            : AppColors.subtext.withValues(alpha: 0.35),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MOVES',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.subtext,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${state.moveCount}',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.headingWhite,
                  ),
                ),
              ],
            ),
            if (state.isHintHelperEnabled)
              if (state.isCheckButtonEnabled)
                Tooltip(
                  key: _solvabilityTooltipKey,
                  message: _solvabilityTooltipMessage,
                  triggerMode: TooltipTriggerMode.manual,
                  preferBelow: false,
                  verticalOffset: 16,
                  showDuration: const Duration(seconds: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A38),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF3E3E4E),
                      width: 1,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await ref
                          .read(gameViewModelProvider.notifier)
                          .checkSolvability();
                      if (result == null || !mounted) return;
                      setState(() {
                        _solvabilityTooltipMessage = switch (result) {
                          SolvabilityStatus.solvable => 'Level is solvable',
                          SolvabilityStatus.unsolvable =>
                            'Level is not solvable',
                          SolvabilityStatus.inconclusive =>
                            'Could not determine. Try again after a few moves.',
                        };
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _solvabilityTooltipKey.currentState
                              ?.ensureTooltipVisible();
                        }
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: Color(0xFF00E676),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'CHECK',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00E676),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () async {
                    final success =
                        await ref.read(gameViewModelProvider.notifier).showHint();
                    if (!success && mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No solution possible from current state. Try undoing some moves!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.lightbulb_rounded,
                          size: 18,
                          color: Color(0xFFFFB300),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'HINT',
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFB300),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildGame(GameViewModelState state) {
    final level = state.level;
    if (level == null) return const SizedBox.shrink();

    return _game != null ? GameWidget(game: _game!) : const SizedBox.shrink();
  }

  void _showCompleteDialog() {
    final state = ref.read(gameViewModelProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF222222), width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final filledStars = state.level?.calculateStars(state.moveCount) ?? 1;
                  final isFilled = index < filledStars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star_rounded,
                      color: isFilled
                          ? AppColors.accent
                          : const Color(0xFF333333),
                      size: index == 1 ? 54 : 44,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                'LEVEL COMPLETE!',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.headingWhite,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.isRandomMode
                    ? 'You sorted this ${state.randomDifficulty} puzzle in ${state.moveCount} moves.'
                    : 'You sorted Level ${widget.levelNumber} in ${state.moveCount} moves.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtext,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TangibleButton(
                    text: state.isRandomMode ? 'Play Again' : 'Next Level',
                    height: 50,
                    onPressed: () async {
                      final notifier = ref.read(gameViewModelProvider.notifier);
                      await notifier.completeLevel();
                      if (!mounted) return;
                      if (context.mounted) {
                        Navigator.pop(context);
                        if (state.isRandomMode) {
                          notifier.loadRandomLevel(
                            state.randomDifficulty ?? 'Easy',
                            colorCount: state.randomColorCount,
                            capacity: state.randomCapacity,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameView(levelNumber: widget.levelNumber + 1),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TangibleButton(
                    text: 'Home',
                    isSecondary: true,
                    height: 50,
                    onPressed: () async {
                      final notifier = ref.read(gameViewModelProvider.notifier);
                      await notifier.completeLevel();
                      if (!mounted) return;
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  TangibleButton(
                    text: 'Buy Me a Coffee ☕',
                    isSecondary: true,
                    height: 50,
                    onPressed: () async {
                      final Uri url = Uri.parse('https://ko-fi.com/sidhant947');
                      try {
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          await launchUrl(url, mode: LaunchMode.platformDefault);
                        }
                      } catch (_) {
                        try {
                          await launchUrl(url, mode: LaunchMode.platformDefault);
                        } catch (_) {}
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _showTimeOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF222222), width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: const Icon(
                  Icons.timer_off_rounded,
                  color: Colors.red,
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "TIME'S UP!",
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.headingWhite,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You ran out of time to sort the water colors.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtext,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TangibleButton(
                    text: 'Try Again',
                    height: 50,
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(gameViewModelProvider.notifier).resetLevel();
                    },
                  ),
                  const SizedBox(height: 12),
                  TangibleButton(
                    text: 'Home',
                    isSecondary: true,
                    height: 50,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showRestartConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF222222), width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.red,
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RESTART LEVEL?',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.headingWhite,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to restart the current level? Your current progress will be lost.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtext,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TangibleButton(
                    text: 'Restart',
                    height: 50,
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(gameViewModelProvider.notifier).resetLevel();
                    },
                  ),
                  const SizedBox(height: 12),
                  TangibleButton(
                    text: 'Cancel',
                    isSecondary: true,
                    height: 50,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
