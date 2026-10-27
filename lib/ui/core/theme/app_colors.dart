import 'package:flutter/material.dart';

enum ThemePack {
  midnight,
  cyberpunk,
  forest,
  space,
  retro,
  sunset,
  neon,
  ocean,
  volcano,
  aurora,
  lavender,
  desert,
  glitch,
  sakura,
  monochrome,
  aquamarine,
  solar,
}

class AppColors {
  AppColors._();

  static ThemePack _activeTheme = ThemePack.midnight;

  static ThemePack get activeTheme => _activeTheme;

  static void setTheme(ThemePack theme) {
    _activeTheme = theme;
  }

  static Color get primary => accent;
  static Color get accent {
    switch (_activeTheme) {
      case ThemePack.midnight: return const Color(0xFF86EF4D);
      case ThemePack.cyberpunk: return const Color(0xFFFF007F);
      case ThemePack.forest: return const Color(0xFF50C878);
      case ThemePack.space: return const Color(0xFFBD93F9);
      case ThemePack.retro: return const Color(0xFFFFB86C);
      case ThemePack.sunset: return const Color(0xFFF9844A);
      case ThemePack.neon: return const Color(0xFF39FF14);
      case ThemePack.ocean: return const Color(0xFF00D2FF);
      case ThemePack.volcano: return const Color(0xFFFF4500);
      case ThemePack.aurora: return const Color(0xFF00FFCC);
      case ThemePack.lavender: return const Color(0xFFE0B0FF);
      case ThemePack.desert: return const Color(0xFFE6C229);
      case ThemePack.glitch: return const Color(0xFF00FF00);
      case ThemePack.sakura: return const Color(0xFFFFB7C5);
      case ThemePack.monochrome: return const Color(0xFFE0E0E0);
      case ThemePack.aquamarine: return const Color(0xFF7FFFD4);
      case ThemePack.solar: return const Color(0xFFFFCC00);
    }
  }

  static Color get headingWhite => const Color(0xFFFFFFFF);
  static Color get subtext => const Color(0xFF808080);

  static Color get bg {
    switch (_activeTheme) {
      case ThemePack.midnight: return const Color(0xFF121212);
      case ThemePack.cyberpunk: return const Color(0xFF0F0B1E);
      case ThemePack.forest: return const Color(0xFF0D140F);
      case ThemePack.space: return const Color(0xFF090A15);
      case ThemePack.retro: return const Color(0xFF17130E);
      case ThemePack.sunset: return const Color(0xFF1E0E25);
      case ThemePack.neon: return const Color(0xFF050505);
      case ThemePack.ocean: return const Color(0xFF0A192F);
      case ThemePack.volcano: return const Color(0xFF1A0A0A);
      case ThemePack.aurora: return const Color(0xFF0B1B1E);
      case ThemePack.lavender: return const Color(0xFF15101F);
      case ThemePack.desert: return const Color(0xFF221A0F);
      case ThemePack.glitch: return const Color(0xFF0D0208);
      case ThemePack.sakura: return const Color(0xFF261820);
      case ThemePack.monochrome: return const Color(0xFF1A1A1A);
      case ThemePack.aquamarine: return const Color(0xFF081C15);
      case ThemePack.solar: return const Color(0xFF200F00);
    }
  }

  static Color get gridLines => const Color(0xFF222222);

  static Color get darkBg => bg;
  static Color get darkSurface => const Color(0xFF16161C);
  static Color get darkCard => const Color(0xFF1C1C22);
  static Color get darkBorder => accent;

  static Color get lightBg => bg;
  static Color get lightSurface => const Color(0xFF16161C);
  static Color get lightCard => const Color(0xFF1C1C22);
  static Color get lightBorder => accent;

  static const List<Color> defaultWaterColors = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFDD835),
    Color(0xFFFF8F00),
    Color(0xFF8E24AA),
    Color(0xFFEC407A),
    Color(0xFF00ACC1),
    Color(0xFFB39DDB),
    Color(0xFFFF7043),
    Color(0xFF5C6BC0),
    Color(0xFF009688),
    Color(0xFF8D6E63),
    Color(0xFFB71C1C),
    Color(0xFFAD1457),
    Color(0xFF9E9D24),
  ];

  static List<Color> _waterColors = List.of(defaultWaterColors);

  static List<Color> get waterColors => _waterColors;

  static void setWaterColors(List<Color> colors) {
    _waterColors = List.of(colors);
  }

  static const List<IconData> waterIcons = [
    Icons.favorite_rounded,
    Icons.water_drop_rounded,
    Icons.eco_rounded,
    Icons.wb_sunny_rounded,
    Icons.star_rounded,
    Icons.dark_mode_rounded,
    Icons.auto_awesome_rounded,
    Icons.ac_unit_rounded,
    Icons.palette_rounded,
    Icons.whatshot_rounded,
    Icons.cloud_rounded,
    Icons.diamond_rounded,
    Icons.cookie_rounded,
    Icons.bolt_rounded,
    Icons.nightlight_rounded,
    Icons.grass_rounded,
  ];

  static final List<Color> _defaultWaterIconColors = List.generate(
    defaultWaterColors.length,
    (i) => defaultWaterColors[i].computeLuminance() > 0.5 ? Colors.black : Colors.white,
  );

  static List<Color> _waterIconColors = List.of(_defaultWaterIconColors);

  static List<Color> get waterIconColors => _waterIconColors;

  static void setWaterIconColors(List<Color> colors) {
    _waterIconColors = List.of(colors);
  }

  static Color getIconColorForSlot(int index) {
    if (index >= 0 && index < _waterIconColors.length) {
      return _waterIconColors[index];
    }
    return Colors.white;
  }

  static Color getIconColorForColor(Color color) {
    final hex = color.toARGB32() & 0xFFFFFF;
    final index = _waterColors.indexWhere((c) => (c.toARGB32() & 0xFFFFFF) == hex);
    return getIconColorForSlot(index);
  }

  static IconData getIconForSlot(int index) {
    if (index >= 0 && index < waterIcons.length) {
      return waterIcons[index];
    }
    return Icons.brightness_1_rounded;
  }

  static IconData getIconForColor(Color color) {
    final hex = color.toARGB32() & 0xFFFFFF;
    final index = _waterColors.indexWhere((c) => (c.toARGB32() & 0xFFFFFF) == hex);
    return getIconForSlot(index);
  }
}

