import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:watersort/ui/core/theme/app_colors.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.0),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.headingWhite,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'SUPPORT',
                        style: TextStyle(
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
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'SUPPORT WATER SORT',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'If you enjoy the game, consider supporting its development.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section: One-time Support
                    _sectionHeader('ONE-TIME SUPPORT'),

                    const SizedBox(height: 12),

                    _supportOption(
                      context,
                      title: 'GitHub Sponsors',
                      description: '100% goes to the developer',
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFFEA4AAA),
                      url: 'https://github.com/sponsors/sidhant947',
                    ),

                    const SizedBox(height: 12),

                    _supportOption(
                      context,
                      title: 'Buy Me a Coffee',
                      description: 'Quick tip to show appreciation',
                      icon: Icons.coffee_rounded,
                      color: const Color(0xFFFFDD00),
                      url: 'https://buymeacoffee.com/sidhant947',
                    ),

                    const SizedBox(height: 12),

                    _supportOption(
                      context,
                      title: 'Ko-fi',
                      description: 'Simple one-time support',
                      icon: Icons.local_cafe_rounded,
                      color: const Color(0xFF29abe0),
                      url: 'https://ko-fi.com/sidhant947',
                    ),

                    const SizedBox(height: 24),

                    // Section: Monthly Support
                    _sectionHeader('RECURRING SUPPORT'),

                    const SizedBox(height: 12),

                    _supportOption(
                      context,
                      title: 'Liberapay',
                      description: 'Weekly recurring donations',
                      icon: Icons.autorenew_rounded,
                      color: const Color(0xFF369449),
                      url: 'https://liberapay.com/sidhant947',
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.subtext,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _supportOption(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.headingWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.subtext,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.subtext,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
