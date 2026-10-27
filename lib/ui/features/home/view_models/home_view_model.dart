import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:watersort/data/repositories/progress_repository.dart';
import 'package:watersort/domain/models/user_progress.dart';
import 'package:watersort/domain/models/user_profile.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';

class HomeViewModelState {
  const HomeViewModelState({
    this.progress,
    this.activeProfile,
    this.profiles = const [],
    this.isLoading = false,
    this.isTimerEnabled = true,
    this.isSuperHardModeEnabled = false,
    this.isBlurSolvedTubesEnabled = false,
    this.isInstantPouringEnabled = false,
    this.isHintHelperEnabled = false,
    this.isCheckButtonEnabled = false,
    this.isUndoDecrementsMovesEnabled = false,
    this.isSoundEffectsEnabled = true,
    this.tubeSize = 'medium',
    this.levelStars = const {},
    this.activeTheme = ThemePack.midnight,
    this.areThemesUnlocked = false,
    this.customBackgroundImagePath,
    this.customWaterColors = AppColors.defaultWaterColors,
    this.customWaterIconColors = const [],
  });

  final UserProgress? progress;
  final UserProfile? activeProfile;
  final List<UserProfile> profiles;
  final bool isLoading;
  final bool isTimerEnabled;
  final bool isSuperHardModeEnabled;
  final bool isBlurSolvedTubesEnabled;
  final bool isInstantPouringEnabled;
  final bool isHintHelperEnabled;
  final bool isCheckButtonEnabled;
  final bool isUndoDecrementsMovesEnabled;
  final bool isSoundEffectsEnabled;
  final String tubeSize;
  final Map<dynamic, dynamic> levelStars;
  final ThemePack activeTheme;
  final bool areThemesUnlocked;
  final String? customBackgroundImagePath;
  final List<Color> customWaterColors;
  final List<Color> customWaterIconColors;

  HomeViewModelState copyWith({
    UserProgress? progress,
    UserProfile? Function()? activeProfile,
    List<UserProfile>? profiles,
    bool? isLoading,
    bool? isTimerEnabled,
    bool? isSuperHardModeEnabled,
    bool? isBlurSolvedTubesEnabled,
    bool? isInstantPouringEnabled,
    bool? isHintHelperEnabled,
    bool? isCheckButtonEnabled,
    bool? isUndoDecrementsMovesEnabled,
    bool? isSoundEffectsEnabled,
    String? tubeSize,
    Map<dynamic, dynamic>? levelStars,
    ThemePack? activeTheme,
    bool? areThemesUnlocked,
    String? Function()? customBackgroundImagePath,
    List<Color>? customWaterColors,
    List<Color>? customWaterIconColors,
  }) {
    return HomeViewModelState(
      progress: progress ?? this.progress,
      activeProfile: activeProfile != null ? activeProfile() : this.activeProfile,
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      isTimerEnabled: isTimerEnabled ?? this.isTimerEnabled,
      isSuperHardModeEnabled:
          isSuperHardModeEnabled ?? this.isSuperHardModeEnabled,
      isBlurSolvedTubesEnabled:
          isBlurSolvedTubesEnabled ?? this.isBlurSolvedTubesEnabled,
      isInstantPouringEnabled:
          isInstantPouringEnabled ?? this.isInstantPouringEnabled,
      isHintHelperEnabled: isHintHelperEnabled ?? this.isHintHelperEnabled,
      isCheckButtonEnabled: isCheckButtonEnabled ?? this.isCheckButtonEnabled,
      isUndoDecrementsMovesEnabled:
          isUndoDecrementsMovesEnabled ?? this.isUndoDecrementsMovesEnabled,
      isSoundEffectsEnabled:
          isSoundEffectsEnabled ?? this.isSoundEffectsEnabled,
      tubeSize: tubeSize ?? this.tubeSize,
      levelStars: levelStars ?? this.levelStars,
      activeTheme: activeTheme ?? this.activeTheme,
      areThemesUnlocked: areThemesUnlocked ?? this.areThemesUnlocked,
      customBackgroundImagePath: customBackgroundImagePath != null
          ? customBackgroundImagePath()
          : this.customBackgroundImagePath,
      customWaterColors: customWaterColors ?? this.customWaterColors,
      customWaterIconColors:
          customWaterIconColors ?? this.customWaterIconColors,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeViewModelState> {
  HomeViewModel({required this._progressRepository})
      : super(const HomeViewModelState()) {
    _progressSubscription = _progressRepository.onProgressChanged.listen((progress) {
      final levelStars = _progressRepository.getAllLevelStars();
      state = state.copyWith(
        progress: progress,
        levelStars: levelStars,
      );
    });
  }

  final ProgressRepository _progressRepository;
  StreamSubscription<UserProgress>? _progressSubscription;

  @override
  void dispose() {
    _progressSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadProgress() async {
    state = state.copyWith(isLoading: true);
    try {
      final progress = await _progressRepository.getProgress();
      final activeProfile = await _progressRepository.getActiveProfile();
      final profiles = await _progressRepository.getProfiles();
      final isTimerEnabled = _progressRepository.isTimerEnabled();
      final isSuperHardModeEnabled = _progressRepository.isSuperHardModeEnabled();
      final isBlurSolvedTubesEnabled = _progressRepository.isBlurSolvedTubesEnabled();
      final isInstantPouringEnabled = _progressRepository.isInstantPouringEnabled();
      final isHintHelperEnabled = _progressRepository.isHintHelperEnabled();
      final isCheckButtonEnabled = isHintHelperEnabled && _progressRepository.isCheckButtonEnabled();
      final isUndoDecrementsMovesEnabled = _progressRepository.isUndoDecrementsMovesEnabled();
      final isSoundEffectsEnabled = _progressRepository.isSoundEffectsEnabled();
      final tubeSize = _progressRepository.getTubeSize();
      final levelStars = _progressRepository.getAllLevelStars();
      final themeName = _progressRepository.getThemePack();
      final areThemesUnlocked = _progressRepository.areThemesUnlocked();
      final customBgPath = _progressRepository.getCustomBackgroundImagePath();
      final theme = ThemePack.values.firstWhere(
        (t) => t.name == themeName,
        orElse: () => ThemePack.midnight,
      );
      AppColors.setTheme(theme);
      final waterColors = _progressRepository.getWaterColors();
      final waterIconColors = _progressRepository.getWaterIconColors();
      AppColors.setWaterColors(waterColors);
      AppColors.setWaterIconColors(waterIconColors);
      state = state.copyWith(
        progress: progress,
        activeProfile: () => activeProfile,
        profiles: profiles,
        isTimerEnabled: isTimerEnabled,
        isSuperHardModeEnabled: isSuperHardModeEnabled,
        isBlurSolvedTubesEnabled: isBlurSolvedTubesEnabled,
        isInstantPouringEnabled: isInstantPouringEnabled,
        isHintHelperEnabled: isHintHelperEnabled,
        isCheckButtonEnabled: isCheckButtonEnabled,
        isUndoDecrementsMovesEnabled: isUndoDecrementsMovesEnabled,
        isSoundEffectsEnabled: isSoundEffectsEnabled,
        tubeSize: tubeSize,
        levelStars: levelStars,
        activeTheme: theme,
        areThemesUnlocked: areThemesUnlocked,
        customBackgroundImagePath: () => customBgPath,
        customWaterColors: waterColors,
        customWaterIconColors: waterIconColors,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setCustomBackgroundImage(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'custom_bg_${DateTime.now().millisecondsSinceEpoch}.png';
    final savedFile = await File(sourcePath).copy('${appDir.path}/$fileName');
    if (state.customBackgroundImagePath != null) {
      try {
        final oldFile = File(state.customBackgroundImagePath!);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (_) {}
    }
    await _progressRepository.setCustomBackgroundImagePath(savedFile.path);
    state = state.copyWith(customBackgroundImagePath: () => savedFile.path);
  }

  Future<void> removeCustomBackgroundImage() async {
    if (state.customBackgroundImagePath != null) {
      try {
        final oldFile = File(state.customBackgroundImagePath!);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (_) {}
    }
    await _progressRepository.setCustomBackgroundImagePath(null);
    state = state.copyWith(customBackgroundImagePath: () => null);
  }

  Future<void> toggleTimer() async {
    final newValue = !state.isTimerEnabled;
    await _progressRepository.setTimerEnabled(newValue);
    state = state.copyWith(isTimerEnabled: newValue);
  }

  Future<void> toggleSuperHardMode() async {
    final newValue = !state.isSuperHardModeEnabled;
    await _progressRepository.setSuperHardModeEnabled(newValue);
    state = state.copyWith(isSuperHardModeEnabled: newValue);
  }

  Future<void> toggleBlurSolvedTubes() async {
    final newValue = !state.isBlurSolvedTubesEnabled;
    await _progressRepository.setBlurSolvedTubesEnabled(newValue);
    state = state.copyWith(isBlurSolvedTubesEnabled: newValue);
  }

  Future<void> toggleInstantPouring() async {
    final newValue = !state.isInstantPouringEnabled;
    await _progressRepository.setInstantPouringEnabled(newValue);
    state = state.copyWith(isInstantPouringEnabled: newValue);
  }

  Future<void> toggleHintHelper() async {
    final newValue = !state.isHintHelperEnabled;
    await _progressRepository.setHintHelperEnabled(newValue);
    await _progressRepository.setCheckButtonEnabled(false);
    state = state.copyWith(
      isHintHelperEnabled: newValue,
      isCheckButtonEnabled: false,
    );
  }

  Future<void> toggleCheckButton() async {
    final newValue = !state.isCheckButtonEnabled;
    await _progressRepository.setCheckButtonEnabled(newValue);
    state = state.copyWith(isCheckButtonEnabled: newValue);
  }

  Future<void> toggleUndoDecrementsMoves() async {
    final newValue = !state.isUndoDecrementsMovesEnabled;
    await _progressRepository.setUndoDecrementsMovesEnabled(newValue);
    state = state.copyWith(isUndoDecrementsMovesEnabled: newValue);
  }

  Future<void> toggleSoundEffects() async {
    final newValue = !state.isSoundEffectsEnabled;
    await _progressRepository.setSoundEffectsEnabled(newValue);
    state = state.copyWith(isSoundEffectsEnabled: newValue);
  }

  Future<void> setTubeSize(String size) async {
    await _progressRepository.setTubeSize(size);
    state = state.copyWith(tubeSize: size);
  }

  Future<void> setThemePack(ThemePack theme) async {
    await _progressRepository.setThemePack(theme.name);
    AppColors.setTheme(theme);
    state = state.copyWith(activeTheme: theme);
  }

  Future<bool> unlockThemesWithCode(String inputCode) async {
    final cleanCode = inputCode.replaceAll(' ', '').trim().toUpperCase();
    if (cleanCode == 'THANKYOU') {
      await _progressRepository.setThemesUnlocked(true);
      state = state.copyWith(areThemesUnlocked: true);
      return true;
    }
    return false;
  }

  Future<void> resetProgress() async {
    await _progressRepository.resetProgress();
    await loadProgress();
  }

  Future<void> createProfile(String name, String emoji) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.createProfile(name, emoji);
    await loadProgress();
  }

  Future<void> switchProfile(String profileId) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.switchProfile(profileId);
    await loadProgress();
  }

  Future<void> deleteProfile(String profileId) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.deleteProfile(profileId);
    await loadProgress();
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.updateProfile(profile);
    await loadProgress();
  }

  Future<void> setWaterColor(int index, Color color, [Color? iconColor]) async {
    final list = List<Color>.of(state.customWaterColors);
    final iconList = List<Color>.of(
      state.customWaterIconColors.isEmpty
          ? AppColors.waterIconColors
          : state.customWaterIconColors,
    );
    if (index >= 0 && index < list.length) {
      list[index] = color;
      if (iconColor != null && index < iconList.length) {
        iconList[index] = iconColor;
        await _progressRepository.saveWaterIconColors(iconList);
        AppColors.setWaterIconColors(iconList);
      }
      await _progressRepository.saveWaterColors(list);
      AppColors.setWaterColors(list);
      state = state.copyWith(
        customWaterColors: list,
        customWaterIconColors: iconList,
      );
    }
  }

  Future<void> setAllWaterColors(List<Color> colors) async {
    if (colors.length == AppColors.defaultWaterColors.length) {
      await _progressRepository.saveWaterColors(colors);
      AppColors.setWaterColors(colors);
      state = state.copyWith(customWaterColors: List<Color>.of(colors));
    }
  }

  Future<void> resetWaterColors() async {
    await _progressRepository.resetWaterColors();
    final defaults = List<Color>.of(AppColors.defaultWaterColors);
    final defaultIcons = List.generate(
      defaults.length,
      (i) => defaults[i].computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );
    AppColors.setWaterColors(defaults);
    AppColors.setWaterIconColors(defaultIcons);
    state = state.copyWith(
      customWaterColors: defaults,
      customWaterIconColors: defaultIcons,
    );
  }

  Future<String> exportBackupJson() async {
    final map = await _progressRepository.exportBackup();
    return jsonEncode(map);
  }

  Future<bool> importBackupJson(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        if (decoded is Map) {
          final converted = decoded.cast<String, dynamic>();
          final success = await _progressRepository.importBackup(converted);
          if (success) await loadProgress();
          return success;
        }
        return false;
      }
      final success = await _progressRepository.importBackup(decoded);
      if (success) await loadProgress();
      return success;
    } catch (_) {
      return false;
    }
  }
}


