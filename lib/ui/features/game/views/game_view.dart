import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/core/widgets/tangible_button.dart';
import 'package:watersort/ui/core/widgets/tube_widget.dart';
import 'package:watersort/ui/features/game/view_models/game_view_model.dart';
import 'package:watersort/ui/providers.dart';

class GameView extends ConsumerStatefulWidget {
  const GameView({
    super.key,
    required this.levelNumber,
    this.isRandom = false,
    this.randomDifficulty = 'Easy',
  });

  final int levelNumber;
  final bool isRandom;
  final String randomDifficulty;

  @override
  ConsumerState<GameView> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<GameView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.isRandom) {
        ref.read(gameViewModelProvider.notifier).loadRandomLevel(widget.randomDifficulty);
      } else {
        ref.read(gameViewModelProvider.notifier).loadLevel(widget.levelNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameViewModelProvider);

    ref.listen<GameViewModelState>(gameViewModelProvider, (prev, next) {
      if (next.isComplete && !(prev?.isComplete ?? false)) {
        _showCompleteDialog();
      }
      if (next.isTimeOut && !(prev?.isTimeOut ?? false)) {
        _showTimeOutDialog();
      }
    });

    final isComplete = state.isComplete;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isComplete) {
          Navigator.pop(context);
        } else {
          _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showExitConfirmationDialog(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C22),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF222222),
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (!state.isRandomMode)
                    Text(
                      'LEVEL ${widget.levelNumber}',
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.headingWhite,
                        letterSpacing: 1.0,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C22),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFF222222),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: state.canUndo
                              ? () => ref.read(gameViewModelProvider.notifier).undoMove()
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Icon(
                              Icons.undo_rounded,
                              size: 20,
                              color: Colors.white.withValues(alpha: state.canUndo ? 1.0 : 0.3),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: const Color(0xFF222222),
                        ),
                        GestureDetector(
                          onTap: () => ref.read(gameViewModelProvider.notifier).resetLevel(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                ],
              ),
            ),

            // Game body
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildGame(GameViewModelState state) {
    final level = state.level;
    if (level == null) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF222222),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('MOVES', '${state.moveCount}', Icons.trending_up_rounded),
              if (state.timeLeft != null) ...[
                _verticalDivider(),
                _stat(
                  'TIME LEFT',
                  _formatTime(state.timeLeft!),
                  Icons.timer_rounded,
                  color: state.timeLeft! <= 15 ? Colors.red : AppColors.accent,
                ),
              ],
            ],
          ),
        ),

        // Tubes Container
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth = constraints.maxWidth;
                final double containerHeight = constraints.maxHeight;

                final int tubeCount = level.tubes.length;
                final int maxPerRow;
                if (tubeCount <= 5) {
                  maxPerRow = tubeCount;
                } else if (tubeCount <= 8) {
                  maxPerRow = 4;
                } else {
                  maxPerRow = 5;
                }
                final int rows = (tubeCount / maxPerRow).ceil();
                final int cols = (tubeCount / rows).ceil();

                const double spacing = 8.0;
                const double aspectRatio = 3.2;

                final double maxTubeWidth = (containerWidth - (cols + 1) * spacing) / cols;
                final double maxTubeHeight = (containerHeight - rows * spacing) / rows;

                double tubeWidth = maxTubeWidth.clamp(0.0, 52.0);
                double tubeHeight = tubeWidth * aspectRatio;

                if (tubeHeight > maxTubeHeight) {
                  tubeHeight = maxTubeHeight.clamp(0.0, 166.0);
                  tubeWidth = tubeHeight / aspectRatio;
                }

                final List<List<int>> tubeRows = [];
                for (int r = 0; r < rows; r++) {
                  final start = r * maxPerRow;
                  final end = (start + maxPerRow).clamp(0, tubeCount);
                  tubeRows.add(List.generate(end - start, (i) => start + i));
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tubeRows.map((rowIndices) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: spacing / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: rowIndices.map((i) {
                          final isSource = state.pouringFromIndex == i;
                          final isTarget = state.pouringToIndex == i;
                          final pourToLeft = isSource &&
                              state.pouringToIndex != null &&
                              state.pouringToIndex! < i;

                          Offset pouringOffset = Offset.zero;
                          if (isSource && state.pouringToIndex != null) {
                            final from = i;
                            final to = state.pouringToIndex!;
                            final fromRow = from ~/ maxPerRow;
                            final fromCol = from % maxPerRow;
                            final toRow = to ~/ maxPerRow;
                            final toCol = to % maxPerRow;
                            final colDiff = toCol - fromCol;
                            final rowDiff = toRow - fromRow;
                            final dx = colDiff * (tubeWidth + spacing);
                            final dy = rowDiff * (tubeHeight + spacing) - tubeHeight - 12.0;
                            pouringOffset = Offset(dx, dy);
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
                            child: TubeWidget(
                              tube: level.tubes[i],
                              isSelected: state.selectedTubeIndex == i,
                              isPouringSource: isSource,
                              isPouringTarget: isTarget,
                              pourToLeft: pourToLeft,
                              pouringOffset: pouringOffset,
                              height: tubeHeight,
                              width: tubeWidth,
                              onTap: () => ref.read(gameViewModelProvider.notifier).selectTube(i),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _stat(String label, String value, IconData icon, {Color? color}) {
    final displayColor = color ?? AppColors.accent;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: displayColor,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: color ?? AppColors.headingWhite,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.subtext,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1.0,
      height: 30,
      color: AppColors.gridLines,
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF222222),
            width: 1.0,
          ),
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
                  Icons.exit_to_app_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'QUIT LEVEL?',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.headingWhite,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your progress in this level will be lost.',
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
              Row(
                children: [
                  Expanded(
                    child: TangibleButton(
                      text: 'Cancel',
                      isSecondary: true,
                      height: 50,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TangibleButton(
                      text: 'Quit',
                      height: 50,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          side: const BorderSide(
            color: Color(0xFF222222),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.accent,
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'LEVEL COMPLETE!',
                style: const TextStyle(
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
                style: const TextStyle(
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
                          notifier.loadRandomLevel(state.randomDifficulty ?? 'Easy');
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameView(levelNumber: widget.levelNumber + 1),
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
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  TangibleButton(
                    text: 'Buy Us a Coffee ☕',
                    isSecondary: true,
                    height: 50,
                    onPressed: () async {
                      final Uri url = Uri.parse('https://github.com/sponsors/sidhant947');
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        debugPrint('Could not launch $url');
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
          side: const BorderSide(
            color: Color(0xFF222222),
            width: 1.0,
          ),
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
              const Text(
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
              const Text(
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
              Row(
                children: [
                  Expanded(
                    child: TangibleButton(
                      text: 'Home',
                      isSecondary: true,
                      height: 50,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TangibleButton(
                      text: 'Try Again',
                      height: 50,
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(gameViewModelProvider.notifier).resetLevel();
                      },
                    ),
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
