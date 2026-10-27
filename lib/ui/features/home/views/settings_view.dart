import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Future<void> _launchExternalUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    try {
      final jsonString = await ref
          .read(homeViewModelProvider.notifier)
          .exportBackupJson();
      final bytes = Uint8List.fromList(utf8.encode(jsonString));
      final fileName =
          'watersort_backup_${DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first}.json';
      final uri = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'application/json',
      );
      if (uri != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup exported successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to export backup.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (files.isEmpty) return;

      final file = files.first;
      final bytes = await file.readAsBytes();
      final jsonString = utf8.decode(bytes);

      final success = await ref
          .read(homeViewModelProvider.notifier)
          .importBackupJson(jsonString);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Backup imported successfully.'
                  : 'Invalid backup file format.',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to import backup.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showResetConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A2A34), width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'RESET PROGRESS?',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.headingWhite,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will erase all completed levels, stars, and saved state for this profile. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.subtext,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF333340)),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 15,
                          color: AppColors.subtext,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await ref
                            .read(homeViewModelProvider.notifier)
                            .resetProgress();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Progress has been reset.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'RESET',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A22),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF282834),
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SETTINGS',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.headingWhite,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 24,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  _buildSectionHeader(
                    icon: Icons.sports_esports_rounded,
                    title: 'GAMEPLAY & RULES',
                  ),
                  _buildCardGroup(
                    children: [
                      _buildSettingRow(
                        icon: Icons.timer_rounded,
                        iconColor: const Color(0xFF38BDF8),
                        title: 'GAMEPLAY TIMER',
                        description:
                            'Add countdown timer to levels for an extra challenge, or keep it off to play relaxed.',
                        value: state.isTimerEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleTimer(),
                      ),
                      _buildDivider(),
                      _buildSettingRow(
                        icon: Icons.lightbulb_rounded,
                        iconColor: const Color(0xFFFFB300),
                        title: 'HINT HELPER',
                        description:
                            'Show a hint button during gameplay to highlight the next optimal move.',
                        value: state.isHintHelperEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleHintHelper(),
                      ),
                      if (state.isHintHelperEnabled) ...[
                        _buildDivider(),
                        _buildSettingRow(
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: const Color(0xFF10B981),
                          title: 'CHECK BUTTON',
                          description:
                              'Replace the hint button with a check button that tells if the level is solvable via tooltip without giving hints.',
                          value: state.isCheckButtonEnabled,
                          onTap: () => ref
                              .read(homeViewModelProvider.notifier)
                              .toggleCheckButton(),
                        ),
                      ],
                      _buildDivider(),
                      _buildSettingRow(
                        icon: Icons.visibility_off_rounded,
                        iconColor: const Color(0xFFA855F7),
                        title: 'SUPER HARD DIFFICULTY',
                        description:
                            'Only reveal the topmost color; all hidden liquid segments beneath are pure white.',
                        value: state.isSuperHardModeEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleSuperHardMode(),
                      ),
                      _buildDivider(),
                      _buildSettingRow(
                        icon: Icons.undo_rounded,
                        iconColor: const Color(0xFFF43F5E),
                        title: 'DECREMENT MOVES ON UNDO',
                        description:
                            'Decrease the move counter when undoing a move.',
                        value: state.isUndoDecrementsMovesEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleUndoDecrementsMoves(),
                      ),
                    ],
                  ),
                  _buildSectionHeader(
                    icon: Icons.volume_up_rounded,
                    title: 'AUDIO & ANIMATIONS',
                  ),
                  _buildCardGroup(
                    children: [
                      _buildSettingRow(
                        icon: state.isSoundEffectsEnabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        iconColor: const Color(0xFF34D399),
                        title: 'SOUND EFFECTS',
                        description:
                            'Liquid pouring sounds, tube completion chimes, and victory fanfare.',
                        value: state.isSoundEffectsEnabled,
                        isEnabled: !state.isInstantPouringEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleSoundEffects(),
                      ),
                      _buildDivider(),
                      _buildSettingRow(
                        icon: Icons.motion_photos_off_rounded,
                        iconColor: const Color(0xFFF87171),
                        title: 'TURN OFF ANIMATIONS',
                        description:
                            'Instant gameplay mode. Disables pouring physics, ripples, waves, and all sound effects.',
                        value: state.isInstantPouringEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleInstantPouring(),
                      ),
                    ],
                  ),
                  _buildSectionHeader(
                    icon: Icons.backup_rounded,
                    title: 'BACKUP & RESTORE',
                  ),
                  _buildCardGroup(
                    children: [
                      _buildActionRow(
                        icon: Icons.file_upload_rounded,
                        iconColor: const Color(0xFF38BDF8),
                        title: 'EXPORT BACKUP',
                        description: 'Save your progress',
                        onTap: () => _exportBackup(context, ref),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF7E7E90),
                          size: 14,
                        ),
                      ),
                      _buildDivider(),
                      _buildActionRow(
                        icon: Icons.file_download_rounded,
                        iconColor: const Color(0xFF10B981),
                        title: 'IMPORT BACKUP',
                        description: 'Restore your progress',
                        onTap: () => _importBackup(context, ref),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF7E7E90),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  _buildSectionHeader(
                    icon: Icons.help_outline_rounded,
                    title: 'SUPPORT & ABOUT',
                  ),
                  _buildCardGroup(
                    children: [
                      _buildActionRow(
                        icon: Icons.bug_report_rounded,
                        iconColor: const Color(0xFFEF4444),
                        title: 'REPORT BUGS / SUGGESTIONS',
                        description:
                            'Open GitHub to submit bug reports or propose new features.',
                        onTap: () => _launchExternalUrl(
                          'https://github.com/sidhant947/water-sort',
                        ),
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          color: Color(0xFF7E7E90),
                          size: 16,
                        ),
                      ),
                      _buildDivider(),
                      _buildActionRow(
                        icon: Icons.coffee_rounded,
                        iconColor: const Color(0xFFF59E0B),
                        title: 'BUY ME A COFFEE',
                        description:
                            'Support independent development and future game updates.',
                        onTap: () =>
                            _launchExternalUrl('https://ko-fi.com/sidhant947'),
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          color: Color(0xFF7E7E90),
                          size: 16,
                        ),
                      ),
                      _buildDivider(),
                      _buildActionRow(
                        icon: Icons.restart_alt_rounded,
                        iconColor: Colors.redAccent,
                        title: 'RESET ALL PROGRESS',
                        description:
                            'Clear all solved level records, stars, and saved states.',
                        onTap: () => _showResetConfirmationDialog(context, ref),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF7E7E90),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10, top: 22),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.subtext,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  Widget _buildCardGroup({required List<Widget> children}) {
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFF1F1F27),
      indent: 68,
      endIndent: 16,
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool value,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return InkWell(
      onTap: isEnabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      splashColor: AppColors.accent.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.38,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: (value && isEnabled)
                      ? iconColor.withValues(alpha: 0.16)
                      : const Color(0xFF1F1F26),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: (value && isEnabled)
                        ? iconColor.withValues(alpha: 0.35)
                        : const Color(0xFF2B2B36),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  icon,
                  color: (value && isEnabled) ? iconColor : AppColors.subtext,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: isEnabled
                            ? AppColors.headingWhite
                            : AppColors.subtext,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtext,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _PremiumSwitch(
                value: value && isEnabled,
                onTap: isEnabled ? onTap : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.accent.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 16,
                      color: AppColors.headingWhite,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.subtext,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF7E7E90),
                  size: 14,
                ),
          ],
        ),
      ),
    );
  }
}

class _PremiumSwitch extends StatelessWidget {
  const _PremiumSwitch({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeInOut,
        width: 48,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value
              ? AppColors.accent.withValues(alpha: 0.18)
              : const Color(0xFF1E1E24),
          border: Border.all(
            color: value ? AppColors.accent : const Color(0xFF33333C),
            width: 1.5,
          ),
          boxShadow: [
            if (value)
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.32),
                blurRadius: 8,
                spreadRadius: 0.8,
              ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? AppColors.accent : const Color(0xFF888896),
                    boxShadow: [
                      if (value)
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
