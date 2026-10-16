import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/ui/providers.dart';

class CustomizationView extends ConsumerWidget {
  const CustomizationView({super.key});

  static const Map<ThemePack, _ThemeSpec> _themeSpecs = {
    ThemePack.midnight: _ThemeSpec(
      name: 'MIDNIGHT',
      bg: Color(0xFF0F0F14),
      accent: Color(0xFF6C5CE7),
    ),
    ThemePack.cyberpunk: _ThemeSpec(
      name: 'CYBERPUNK',
      bg: Color(0xFF0F0B1E),
      accent: Color(0xFFFF007F),
    ),
    ThemePack.forest: _ThemeSpec(
      name: 'FOREST',
      bg: Color(0xFF0D140F),
      accent: Color(0xFF50C878),
    ),
    ThemePack.space: _ThemeSpec(
      name: 'SPACE',
      bg: Color(0xFF090A15),
      accent: Color(0xFFBD93F9),
    ),
    ThemePack.retro: _ThemeSpec(
      name: 'RETRO',
      bg: Color(0xFF17130E),
      accent: Color(0xFFFFB86C),
    ),
    ThemePack.sunset: _ThemeSpec(
      name: 'SUNSET',
      bg: Color(0xFF1E0E25),
      accent: Color(0xFFF9844A),
    ),
    ThemePack.neon: _ThemeSpec(
      name: 'NEON',
      bg: Color(0xFF050505),
      accent: Color(0xFF39FF14),
    ),
    ThemePack.ocean: _ThemeSpec(
      name: 'OCEAN',
      bg: Color(0xFF0A192F),
      accent: Color(0xFF00D2FF),
    ),
    ThemePack.volcano: _ThemeSpec(
      name: 'VOLCANO',
      bg: Color(0xFF1A0A0A),
      accent: Color(0xFFFF4500),
    ),
    ThemePack.aurora: _ThemeSpec(
      name: 'AURORA',
      bg: Color(0xFF0B1B1E),
      accent: Color(0xFF00FFCC),
    ),
    ThemePack.lavender: _ThemeSpec(
      name: 'LAVENDER',
      bg: Color(0xFF15101F),
      accent: Color(0xFFE0B0FF),
    ),
    ThemePack.desert: _ThemeSpec(
      name: 'DESERT',
      bg: Color(0xFF221A0F),
      accent: Color(0xFFE6C229),
    ),
    ThemePack.glitch: _ThemeSpec(
      name: 'GLITCH',
      bg: Color(0xFF0D0208),
      accent: Color(0xFF00FF00),
    ),
    ThemePack.sakura: _ThemeSpec(
      name: 'SAKURA',
      bg: Color(0xFF261820),
      accent: Color(0xFFFFB7C5),
    ),
    ThemePack.monochrome: _ThemeSpec(
      name: 'MONOCHROME',
      bg: Color(0xFF1A1A1A),
      accent: Color(0xFFE0E0E0),
    ),
    ThemePack.aquamarine: _ThemeSpec(
      name: 'AQUAMARINE',
      bg: Color(0xFF081C15),
      accent: Color(0xFF7FFFD4),
    ),
    ThemePack.solar: _ThemeSpec(
      name: 'SOLAR',
      bg: Color(0xFF200F00),
      accent: Color(0xFFFFCC00),
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final activeSpec =
        _themeSpecs[state.activeTheme] ?? _themeSpecs[ThemePack.midnight]!;

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
                        'CUSTOMIZATION',
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
                    icon: Icons.palette_rounded,
                    title: 'THEME PALETTES',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: activeSpec.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: activeSpec.accent.withValues(alpha: 0.4),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: activeSpec.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            activeSpec.name,
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 13,
                              color: activeSpec.accent,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: ThemePack.values.map((theme) {
                        final spec = _themeSpecs[theme]!;
                        final isSelected = state.activeTheme == theme;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .setThemePack(theme);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: spec.bg,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? spec.accent
                                      : const Color(0xFF383848),
                                  width: isSelected ? 2.5 : 1.2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: spec.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check_rounded,
                                          size: 14,
                                          color: spec.bg,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  _buildSectionHeader(
                    icon: Icons.water_drop_rounded,
                    title: 'CUSTOMIZE LIQUID COLORS',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _showJsonThemeDialog(
                              context,
                              ref,
                              state.customWaterColors,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E28),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF333342),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.code_rounded,
                                  size: 12,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'JSON',
                                  style: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontSize: 12,
                                    color: AppColors.accent,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(homeViewModelProvider.notifier)
                                .resetWaterColors();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Liquid colors reset to default.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E28),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF333342),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 12,
                                  color: AppColors.subtext,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'RESET ALL',
                                  style: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontSize: 12,
                                    color: AppColors.subtext,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildLiquidColorsGrid(context, ref, state.customWaterColors),
                  _buildSectionHeader(
                    icon: Icons.auto_awesome_rounded,
                    title: 'AUDIO & VISUALS',
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
                      _buildDivider(),
                      _buildSettingRow(
                        icon: Icons.blur_on_rounded,
                        iconColor: const Color(0xFF2DD4BF),
                        title: 'FROST SOLVED TUBES',
                        description:
                            'Apply an icy glass frosting effect to completed tubes to easily focus on active ones.',
                        value: state.isBlurSolvedTubesEnabled,
                        onTap: () => ref
                            .read(homeViewModelProvider.notifier)
                            .toggleBlurSolvedTubes(),
                      ),
                      _buildDivider(),
                      _buildTubeSizeSelector(context, ref, state.tubeSize),
                      _buildDivider(),
                      _buildCustomBackgroundTile(
                        context,
                        ref,
                        state.customBackgroundImagePath,
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

  Widget _buildTubeSizeSelector(
    BuildContext context,
    WidgetRef ref,
    String currentSize,
  ) {
    const options = [
      {'key': 'slim', 'label': 'SLIM'},
      {'key': 'medium', 'label': 'MEDIUM'},
      {'key': 'wide', 'label': 'WIDE'},
      {'key': 'adaptive', 'label': 'ADAPTIVE'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  Icons.view_column_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TUBE THICKNESS',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.headingWhite,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Choose how wide or thin test tubes look on screen.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtext,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF121218),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF242430)),
            ),
            child: Row(
              children: options.map((opt) {
                final isSelected = currentSize == opt['key'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref
                          .read(homeViewModelProvider.notifier)
                          .setTubeSize(opt['key']!);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        opt['label']!,
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.subtext,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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

  Widget _buildCustomBackgroundTile(
    BuildContext context,
    WidgetRef ref,
    String? customBgPath,
  ) {
    final bool hasBg = customBgPath != null && File(customBgPath).existsSync();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEC4899).withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: const Icon(
                  Icons.image_rounded,
                  color: Color(0xFFEC4899),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUSTOM BACKGROUND IMAGE',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.headingWhite,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Set custom image from your deviice for gameplay background.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtext,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (hasBg) ...[
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2C2C38)),
                image: DecorationImage(
                  image: FileImage(File(customBgPath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Color(0xFF333342)),
                  ),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      await ref
                          .read(homeViewModelProvider.notifier)
                          .setCustomBackgroundImage(pickedFile.path);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Custom background image set successfully.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.photo_library_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    hasBg ? 'CHANGE IMAGE' : 'SET BACKGROUND IMAGE',
                    style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 14,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              if (hasBg) ...[
                const SizedBox(width: 10),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.redAccent,
                        width: 0.8,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await ref
                        .read(homeViewModelProvider.notifier)
                        .removeCustomBackgroundImage();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Custom background image removed.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidColorsGrid(
    BuildContext context,
    WidgetRef ref,
    List<Color> colors,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        final isDarkText = color.computeLuminance() > 0.5;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            _showColorPickerDialog(context, ref, index, color);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF16161C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF262632), width: 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.35),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    AppColors.getIconForSlot(index),
                    size: 16,
                    color: isDarkText ? Colors.black87 : Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.subtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showColorPickerDialog(
    BuildContext context,
    WidgetRef ref,
    int slotIndex,
    Color initialColor,
  ) {
    Color currentColor = initialColor;
    HSLColor currentHsl = HSLColor.fromColor(initialColor);
    final textController = TextEditingController(
      text: (initialColor.toARGB32() & 0xFFFFFF)
          .toRadixString(16)
          .padLeft(6, '0')
          .toUpperCase(),
    );

    const presetColors = [
      Color(0xFFE53935),
      Color(0xFFE91E63),
      Color(0xFF9C27B0),
      Color(0xFF673AB7),
      Color(0xFF3F51B5),
      Color(0xFF2196F3),
      Color(0xFF03A9F4),
      Color(0xFF00BCD4),
      Color(0xFF009688),
      Color(0xFF4CAF50),
      Color(0xFF8BC34A),
      Color(0xFFCDDC39),
      Color(0xFFFFEB3B),
      Color(0xFFFFC107),
      Color(0xFFFF9800),
      Color(0xFFFF5722),
      Color(0xFF00E676),
      Color(0xFF00B0FF),
      Color(0xFFFF1744),
      Color(0xFFFFEA00),
      Color(0xFFD500F9),
      Color(0xFF8D6E63),
      Color(0xFF78909C),
      Color(0xFFFFFFFF),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            final isDarkText = currentColor.computeLuminance() > 0.5;
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              backgroundColor: const Color(0xFF181818),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF2A2A34), width: 1.0),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: currentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            AppColors.getIconForSlot(slotIndex),
                            size: 18,
                            color: isDarkText ? Colors.black87 : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'CUSTOMIZE COLOR',
                              style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.headingWhite,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101014),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF282834)),
                      ),
                      child: Row(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'HEX #',
                              style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 16,
                                color: AppColors.subtext,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: textController,
                              style: TextStyle(
                                color: AppColors.headingWhite,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                border: InputBorder.none,
                                hintText: 'RRGGBB',
                                hintStyle: TextStyle(
                                  color: Color(0xFF555566),
                                ),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9a-fA-F]'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val.length == 6) {
                                  final parsed = int.tryParse(
                                    'FF$val',
                                    radix: 16,
                                  );
                                  if (parsed != null) {
                                    setState(() {
                                      currentColor = Color(parsed);
                                      currentHsl = HSLColor.fromColor(currentColor);
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: currentColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF444455),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'HSL ADJUSTMENT',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 13,
                          color: AppColors.subtext,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildHslSliderRow(
                      label: 'H',
                      valueText: '${currentHsl.hue.round()}°',
                      value: currentHsl.hue,
                      min: 0,
                      max: 360,
                      onChanged: (val) {
                        setState(() {
                          currentHsl = currentHsl.withHue(val);
                          currentColor = currentHsl.toColor();
                          textController.text = (currentColor.toARGB32() & 0xFFFFFF)
                              .toRadixString(16)
                              .padLeft(6, '0')
                              .toUpperCase();
                        });
                      },
                    ),
                    _buildHslSliderRow(
                      label: 'S',
                      valueText: '${(currentHsl.saturation * 100).round()}%',
                      value: currentHsl.saturation,
                      min: 0,
                      max: 1,
                      onChanged: (val) {
                        setState(() {
                          currentHsl = currentHsl.withSaturation(val);
                          currentColor = currentHsl.toColor();
                          textController.text = (currentColor.toARGB32() & 0xFFFFFF)
                              .toRadixString(16)
                              .padLeft(6, '0')
                              .toUpperCase();
                        });
                      },
                    ),
                    _buildHslSliderRow(
                      label: 'L',
                      valueText: '${(currentHsl.lightness * 100).round()}%',
                      value: currentHsl.lightness,
                      min: 0,
                      max: 1,
                      onChanged: (val) {
                        setState(() {
                          currentHsl = currentHsl.withLightness(val);
                          currentColor = currentHsl.toColor();
                          textController.text = (currentColor.toARGB32() & 0xFFFFFF)
                              .toRadixString(16)
                              .padLeft(6, '0')
                              .toUpperCase();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PALETTE PRESETS',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 13,
                          color: AppColors.subtext,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: presetColors.map((color) {
                        final isSelected =
                            (color.toARGB32() & 0xFFFFFF) ==
                            (currentColor.toARGB32() & 0xFFFFFF);
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              currentColor = color;
                              currentHsl = HSLColor.fromColor(color);
                              textController.text =
                                  (color.toARGB32() & 0xFFFFFF)
                                      .toRadixString(16)
                                      .padLeft(6, '0')
                                      .toUpperCase();
                            });
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : const Color(0xFF333344),
                                width: isSelected ? 2.5 : 1.0,
                              ),
                            ),
                            child:
                                isSelected
                                    ? Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color:
                                          color.computeLuminance() > 0.5
                                              ? Colors.black87
                                              : Colors.white,
                                    )
                                    : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    final defaultColor =
                                        AppColors.defaultWaterColors[slotIndex];
                                    setState(() {
                                      currentColor = defaultColor;
                                      currentHsl = HSLColor.fromColor(defaultColor);
                                      textController.text =
                                          (defaultColor.toARGB32() & 0xFFFFFF)
                                              .toRadixString(16)
                                              .padLeft(6, '0')
                                              .toUpperCase();
                                    });
                                  },
                                  child: Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontFamily: 'BebasNeue',
                                      fontSize: 14,
                                      color: AppColors.subtext,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFF333340),
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          fontFamily: 'BebasNeue',
                                          fontSize: 14,
                                          color: AppColors.subtext,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: AppColors.accent,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        ref
                                            .read(
                                              homeViewModelProvider.notifier,
                                            )
                                            .setWaterColor(
                                              slotIndex,
                                              currentColor,
                                            );
                                        Navigator.pop(dialogContext);
                                      },
                                      child: const Text(
                                        'APPLY',
                                        style: TextStyle(
                                          fontFamily: 'BebasNeue',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHslSliderRow({
    required String label,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.subtext,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: const Color(0xFF282834),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            valueText,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.headingWhite,
            ),
          ),
        ),
      ],
    );
  }

  void _showJsonThemeDialog(
    BuildContext context,
    WidgetRef ref,
    List<Color> currentColors,
  ) {
    final hexList = currentColors
        .map(
          (c) =>
              '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
        )
        .toList();
    final initialJson = const JsonEncoder.withIndent('  ').convert(hexList);
    final textController = TextEditingController(text: initialJson);
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              backgroundColor: const Color(0xFF181818),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF2A2A34), width: 1.0),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.code_rounded,
                            size: 18,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'THEME JSON',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.headingWhite,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: textController.text),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Theme JSON copied to clipboard.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.paste_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final data = await Clipboard.getData(
                              Clipboard.kTextPlain,
                            );
                            if (data != null && data.text != null) {
                              setState(() {
                                textController.text = data.text!;
                                errorMessage = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Copy, paste or edit 16 liquid colors formatted as a JSON array of hex codes.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtext,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 180,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101014),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              errorMessage != null
                                  ? Colors.redAccent
                                  : const Color(0xFF282834),
                        ),
                      ),
                      child: TextField(
                        controller: textController,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(color: Color(0xFF333340)),
                          ),
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 14,
                              color: AppColors.subtext,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            try {
                              final decoded = jsonDecode(textController.text);
                              if (decoded is! List) {
                                setState(() {
                                  errorMessage =
                                      'JSON must be a list of 16 hex colors.';
                                });
                                return;
                              }
                              if (decoded.length !=
                                  AppColors.defaultWaterColors.length) {
                                setState(() {
                                  errorMessage =
                                      'Must contain exactly ${AppColors.defaultWaterColors.length} colors (found ${decoded.length}).';
                                });
                                return;
                              }
                              final List<Color> parsedColors = [];
                              for (var item in decoded) {
                                if (item is! String) {
                                  setState(() {
                                    errorMessage =
                                        'Every color item must be a hex string.';
                                  });
                                  return;
                                }
                                var clean = item.trim().replaceFirst('#', '');
                                if (clean.length == 3) {
                                  clean =
                                      'FF${clean[0]}${clean[0]}${clean[1]}${clean[1]}${clean[2]}${clean[2]}';
                                } else if (clean.length == 6) {
                                  clean = 'FF$clean';
                                } else if (clean.length != 8) {
                                  setState(() {
                                    errorMessage = 'Invalid hex color: $item';
                                  });
                                  return;
                                }
                                final val = int.tryParse(clean, radix: 16);
                                if (val == null) {
                                  setState(() {
                                    errorMessage = 'Invalid hex color: $item';
                                  });
                                  return;
                                }
                                parsedColors.add(Color(val));
                              }
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .setAllWaterColors(parsedColors);
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Theme applied successfully.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } catch (_) {
                              setState(() {
                                errorMessage = 'Invalid JSON syntax.';
                              });
                            }
                          },
                          child: const Text(
                            'APPLY',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ThemeSpec {
  final String name;
  final Color bg;
  final Color accent;
  const _ThemeSpec({
    required this.name,
    required this.bg,
    required this.accent,
  });
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
