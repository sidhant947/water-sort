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
}
