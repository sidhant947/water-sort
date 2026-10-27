import 'package:hive_flutter/hive_flutter.dart';
import 'package:watersort/domain/models/user_progress.dart';
import 'package:watersort/domain/models/user_profile.dart';
import 'user_progress_adapter.dart';
import 'user_profile_adapter.dart';

class HiveService {
  static const String _progressBoxName = 'user_progress';
  static const String _profilesBoxName = 'user_profiles';
  static const String _settingsBoxName = 'game_settings';
  static const String _activeProfileKey = 'active_profile_id';
  static const String _legacyProgressKey = 'progress';

  late Box<UserProgress> _progressBox;
  late Box<UserProfile> _profilesBox;
  late Box<dynamic> _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProgressAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserProfileAdapter());
    }

    _progressBox = await Hive.openBox<UserProgress>(_progressBoxName);
    _profilesBox = await Hive.openBox<UserProfile>(_profilesBoxName);
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);

    // Migration / Initialization of default profile
    if (_profilesBox.isEmpty) {
      const defaultProfileId = 'default_profile';
      final defaultProfile = UserProfile(
        id: defaultProfileId,
        name: 'Player 1',
        createdAt: DateTime.now(),
        avatarEmoji: '🧪',
      );
      await _profilesBox.put(defaultProfileId, defaultProfile);

      final legacyProgress = _progressBox.get(_legacyProgressKey);
      if (legacyProgress != null) {
        await _progressBox.put('progress_$defaultProfileId', legacyProgress);
        await _progressBox.delete(_legacyProgressKey);
      }
      
      await _settingsBox.put(_activeProfileKey, defaultProfileId);
    }
  }

  Future<List<UserProfile>> getProfiles() async {
    return _profilesBox.values.toList();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _profilesBox.put(profile.id, profile);
  }

  Future<void> deleteProfile(String profileId) async {
    await _profilesBox.delete(profileId);
    await _progressBox.delete('progress_$profileId');
    
    final activeId = await getActiveProfileId();
    if (activeId == profileId) {
      final remains = await getProfiles();
      if (remains.isNotEmpty) {
        await setActiveProfileId(remains.first.id);
      } else {
        await _settingsBox.delete(_activeProfileKey);
      }
    }
  }

  Future<String?> getActiveProfileId() async {
    return _settingsBox.get(_activeProfileKey) as String?;
  }

  Future<void> setActiveProfileId(String profileId) async {
    await _settingsBox.put(_activeProfileKey, profileId);
  }

  Future<UserProgress> getProgress(String profileId) async {
    return _progressBox.get('progress_$profileId') ?? const UserProgress();
  }

  Future<void> saveProgress(String profileId, UserProgress progress) async {
    await _progressBox.put('progress_$profileId', progress);
  }

  Future<void> clearProgress(String profileId) async {
    await _progressBox.delete('progress_$profileId');
  }

  String _getActiveProfileIdSync() {
    return _settingsBox.get(_activeProfileKey)?.toString() ?? 'default_profile';
  }

  bool isTimerEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_timer_enabled');
    return val == null ? true : val == true;
  }

  Future<void> setTimerEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_timer_enabled', enabled);
  }

  bool isSuperHardModeEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_super_hard_mode');
    return val == true;
  }

  Future<void> setSuperHardModeEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_super_hard_mode', enabled);
  }

  bool isBlurSolvedTubesEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_blur_solved_tubes');
    return val == true;
  }

  Future<void> setBlurSolvedTubesEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_blur_solved_tubes', enabled);
  }

  bool isInstantPouringEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_instant_pouring');
    return val == true;
  }

  Future<void> setInstantPouringEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_instant_pouring', enabled);
  }

  bool isHintHelperEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_hint_helper');
    return val == true;
  }

  Future<void> setHintHelperEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_hint_helper', enabled);
  }

  bool isCheckButtonEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_check_button_enabled');
    return val == true;
  }

  Future<void> setCheckButtonEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_check_button_enabled', enabled);
  }

  bool isUndoDecrementsMovesEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_undo_decrements_moves');
    return val == true;
  }

  Future<void> setUndoDecrementsMovesEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_undo_decrements_moves', enabled);
  }

  bool isSoundEffectsEnabled() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_sound_effects');
    return val == null ? true : val == true;
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_sound_effects', enabled);
  }

  String getTubeSize() {
    final profileId = _getActiveProfileIdSync();
    return _settingsBox.get('${profileId}_tube_size')?.toString() ?? 'medium';
  }

  Future<void> setTubeSize(String size) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_tube_size', size);
  }

  Map<dynamic, dynamic>? getSavedLevelState() {
    final profileId = _getActiveProfileIdSync();
    final raw = _settingsBox.get('${profileId}_saved_level_state');
    if (raw is Map) {
      return Map<dynamic, dynamic>.from(raw);
    }
    return null;
  }

  Future<void> saveActiveLevelState(Map<dynamic, dynamic> stateMap) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_saved_level_state', stateMap);
  }

  Future<void> clearActiveLevelState() async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.delete('${profileId}_saved_level_state');
  }

  Map<dynamic, dynamic> getAllLevelStars() {
    final profileId = _getActiveProfileIdSync();
    final raw = _settingsBox.get('${profileId}_level_stars');
    if (raw is Map) {
      return Map<dynamic, dynamic>.from(raw);
    }
    return <dynamic, dynamic>{};
  }

  Future<void> saveLevelStars(int levelNumber, int stars) async {
    final profileId = _getActiveProfileIdSync();
    final starsMap = Map<dynamic, dynamic>.from(getAllLevelStars());
    starsMap[levelNumber] = stars;
    await _settingsBox.put('${profileId}_level_stars', starsMap);
  }

  String getThemePack() {
    final profileId = _getActiveProfileIdSync();
    return _settingsBox.get('${profileId}_theme_pack')?.toString() ?? 'midnight';
  }

  Future<void> setThemePack(String themeName) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('${profileId}_theme_pack', themeName);
  }

  bool areThemesUnlocked() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('themes_unlocked') ?? _settingsBox.get('${profileId}_themes_unlocked');
    return val == true;
  }

  Future<void> setThemesUnlocked(bool unlocked) async {
    final profileId = _getActiveProfileIdSync();
    await _settingsBox.put('themes_unlocked', unlocked);
    await _settingsBox.put('${profileId}_themes_unlocked', unlocked);
  }

  String? getCustomBackgroundImagePath() {
    final profileId = _getActiveProfileIdSync();
    return _settingsBox.get('${profileId}_custom_bg_path')?.toString();
  }

  Future<void> setCustomBackgroundImagePath(String? path) async {
    final profileId = _getActiveProfileIdSync();
    if (path == null || path.isEmpty) {
      await _settingsBox.delete('${profileId}_custom_bg_path');
    } else {
      await _settingsBox.put('${profileId}_custom_bg_path', path);
    }
  }

  List<int>? getCustomWaterColors() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_custom_water_colors');
    if (val is List) {
      return val.cast<int>();
    }
    return null;
  }

  Future<void> setCustomWaterColors(List<int>? colors) async {
    final profileId = _getActiveProfileIdSync();
    if (colors == null) {
      await _settingsBox.delete('${profileId}_custom_water_colors');
    } else {
      await _settingsBox.put('${profileId}_custom_water_colors', colors);
    }
  }

  List<int>? getCustomWaterIconColors() {
    final profileId = _getActiveProfileIdSync();
    final val = _settingsBox.get('${profileId}_custom_water_icon_colors');
    if (val is List) {
      return val.cast<int>();
    }
    return null;
  }

  Future<void> setCustomWaterIconColors(List<int>? colors) async {
    final profileId = _getActiveProfileIdSync();
    if (colors == null) {
      await _settingsBox.delete('${profileId}_custom_water_icon_colors');
    } else {
      await _settingsBox.put('${profileId}_custom_water_icon_colors', colors);
    }
  }

  Future<Map<String, dynamic>> exportBackup() async {
    final profiles = await getProfiles();
    final activeProfileId = await getActiveProfileId();
    final profilesData = <Map<String, dynamic>>[];
    for (final profile in profiles) {
      final progress = await getProgress(profile.id);
      final rawStars = _settingsBox.get('${profile.id}_level_stars');
      final Map<String, int> stars = {};
      if (rawStars is Map) {
        rawStars.forEach((k, v) {
          final intVal = (v is num) ? v.toInt() : int.tryParse(v.toString());
          if (intVal != null) {
            stars[k.toString()] = intVal;
          }
        });
      }
      profilesData.add({
        'profile': {
          'id': profile.id,
          'name': profile.name,
          'createdAt': profile.createdAt.toIso8601String(),
          'avatarEmoji': profile.avatarEmoji,
        },
        'progress': {
          'currentLevel': progress.currentLevel,
          'highestLevelCompleted': progress.highestLevelCompleted,
          'totalMoves': progress.totalMoves,
        },
        'stars': stars,
        'settings': {
          'timer_enabled': _settingsBox.get('${profile.id}_timer_enabled'),
          'super_hard_mode': _settingsBox.get('${profile.id}_super_hard_mode'),
          'blur_solved_tubes': _settingsBox.get('${profile.id}_blur_solved_tubes'),
          'instant_pouring': _settingsBox.get('${profile.id}_instant_pouring'),
          'hint_helper': _settingsBox.get('${profile.id}_hint_helper'),
          'check_button_enabled': _settingsBox.get('${profile.id}_check_button_enabled'),
          'undo_decrements_moves': _settingsBox.get('${profile.id}_undo_decrements_moves'),
          'sound_effects': _settingsBox.get('${profile.id}_sound_effects'),
          'tube_size': _settingsBox.get('${profile.id}_tube_size'),
          'theme_pack': _settingsBox.get('${profile.id}_theme_pack'),
          'themes_unlocked': _settingsBox.get('${profile.id}_themes_unlocked'),
        },
      });
    }
    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'activeProfileId': activeProfileId,
      'themes_unlocked': _settingsBox.get('themes_unlocked'),
      'profiles': profilesData,
    };
  }

  Future<bool> importBackup(Map<String, dynamic> data) async {
    final rawProfiles = data['profiles'];
    if (rawProfiles is! List || rawProfiles.isEmpty) {
      return false;
    }
    for (final item in rawProfiles) {
      if (item is! Map) continue;
      final profMap = item['profile'];
      if (profMap is! Map) continue;
      final id = profMap['id']?.toString();
      final name = profMap['name']?.toString() ?? 'Player';
      if (id == null || id.isEmpty) continue;
      DateTime createdAt = DateTime.now();
      if (profMap['createdAt'] != null) {
        createdAt = DateTime.tryParse(profMap['createdAt'].toString()) ?? DateTime.now();
      }
      final avatarEmoji = profMap['avatarEmoji']?.toString() ?? '🧪';
      await saveProfile(UserProfile(
        id: id,
        name: name,
        createdAt: createdAt,
        avatarEmoji: avatarEmoji,
      ));

      final progMap = item['progress'];
      if (progMap is Map) {
        await saveProgress(
          id,
          UserProgress(
            currentLevel: (progMap['currentLevel'] as num?)?.toInt() ?? 1,
            highestLevelCompleted: (progMap['highestLevelCompleted'] as num?)?.toInt() ?? 0,
            totalMoves: (progMap['totalMoves'] as num?)?.toInt() ?? 0,
          ),
        );
      }

      final starsMap = item['stars'];
      if (starsMap is Map) {
        final Map<dynamic, dynamic> stars = {};
        starsMap.forEach((k, v) {
          final kInt = int.tryParse(k.toString());
          if (kInt != null && v is num) {
            stars[kInt] = v.toInt();
          }
        });
        await _settingsBox.put('${id}_level_stars', stars);
      }

      final settMap = item['settings'];
      if (settMap is Map) {
        for (final entry in settMap.entries) {
          if (entry.value != null) {
            await _settingsBox.put('${id}_${entry.key}', entry.value);
          }
        }
      }
    }

    if (data['themes_unlocked'] == true) {
      await _settingsBox.put('themes_unlocked', true);
    }

    final activeId = data['activeProfileId']?.toString();
    if (activeId != null && _profilesBox.containsKey(activeId)) {
      await setActiveProfileId(activeId);
    } else if (_profilesBox.isNotEmpty) {
      await setActiveProfileId(_profilesBox.keys.first.toString());
    }
    return true;
  }
}


