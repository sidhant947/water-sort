import 'package:flutter/material.dart';
import 'package:watersort/l10n/app_localizations.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/core/widgets/tangible_button.dart';

class HowToPlayView extends StatelessWidget {
  const HowToPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        l10n.howToPlayTitle,
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.headingWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _step(
                      context,
                      1,
                      l10n.howToPlayStep1Title,
                      l10n.howToPlayStep1Desc,
                      Icons.touch_app_rounded,
                    ),
                    const SizedBox(height: 16),
                    _step(
                      context,
                      2,
                      l10n.howToPlayStep2Title,
                      l10n.howToPlayStep2Desc,
                      Icons.water_drop_rounded,
                    ),
                    const SizedBox(height: 16),
                    _step(
                      context,
                      3,
                      l10n.howToPlayStep3Title,
                      l10n.howToPlayStep3Desc,
                      Icons.done_all_rounded,
                    ),
                    const SizedBox(height: 16),
                    _step(
                      context,
                      4,
                      l10n.howToPlayStep4Title,
                      l10n.howToPlayStep4Desc,
                      Icons.accessibility_new_rounded,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: TangibleButton(
                text: l10n.gotIt,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(BuildContext context, int num, String title, String desc, IconData icon) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF222222),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C22),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.accent,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.15),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(child: Icon(icon, color: AppColors.accent, size: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.howToPlayStep(num),
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headingWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 15,
                    color: AppColors.subtext,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
