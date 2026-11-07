import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:watersort/l10n/app_localizations.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/features/game/views/game_view.dart';
import 'package:watersort/ui/providers.dart';

class LevelSelectView extends ConsumerStatefulWidget {
  const LevelSelectView({super.key});

  @override
  ConsumerState<LevelSelectView> createState() => _LevelSelectViewState();
}

class _LevelSelectViewState extends ConsumerState<LevelSelectView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeViewModelProvider.notifier).loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final highestCompleted = state.progress?.highestLevelCompleted ?? 0;
    final currentLevel = state.progress?.currentLevel ?? 1;

    final int totalLevelsToShow = currentLevel + 10;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.levelsTitle,
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.headingWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  // Balanced invisible spacer to perfectly center the text
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Grid of levels
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.0,
                ),
                itemCount: totalLevelsToShow,
                itemBuilder: (context, index) {
                  final levelNumber = index + 1;
                  final isCompleted = levelNumber <= highestCompleted;
                  final isCurrent = levelNumber == currentLevel;
                  final isLocked = levelNumber > currentLevel;

                  return _buildLevelCard(
                    context,
                    levelNumber: levelNumber,
                    isCompleted: isCompleted,
                    isCurrent: isCurrent,
                    isLocked: isLocked,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context, {
    required int levelNumber,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLocked,
  }) {
    Color cardBg = const Color(0xFF16161C).withOpacity(0.85);
    Color borderColor = const Color(0xFF222222);
    Widget content;
    bool isClickable = !isLocked;

    if (isCompleted) {
      borderColor = AppColors.accent.withOpacity(0.4);
      final state = ref.read(homeViewModelProvider);
      final stars = (state.levelStars[levelNumber] ?? state.levelStars[levelNumber.toString()] ?? 0) as int;
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$levelNumber',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 20,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (starIndex) {
              final isStarred = starIndex < (stars > 0 ? stars : 3);
              return Icon(
                Icons.star_rounded,
                size: 10,
                color: isStarred ? AppColors.accent : const Color(0xFF333333),
              );
            }),
          ),
        ],
      );
    } else if (isCurrent) {
      borderColor = AppColors.accent;
      cardBg = const Color(0xFF1C1C22);
      content = Text(
        '$levelNumber',
        style: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 26,
          color: AppColors.accent,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      // Locked state
      content = Icon(
        Icons.lock_outline_rounded,
        size: 18,
        color: AppColors.subtext,
      );
    }

    return GestureDetector(
      onTap: isClickable
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameView(levelNumber: levelNumber),
                ),
              );
              // Refresh when returning to update completions
              ref.read(homeViewModelProvider.notifier).loadProgress();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: isCurrent ? 1.8 : 1.0,
          ),
          boxShadow: [
            if (isCurrent)
              BoxShadow(
                color: AppColors.accent.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              )
            else if (!isLocked)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
