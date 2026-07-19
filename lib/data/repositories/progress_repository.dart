import 'package:watersort/domain/models/user_progress.dart';
import 'package:watersort/domain/models/user_profile.dart';
import '../services/hive_service.dart';

class ProgressRepository {
  ProgressRepository({required this._hiveService});

  final HiveService _hiveService;
  UserProgress? _cachedProgress;
  String? _cachedActiveProfileId;

  Future<String> _getActiveProfileId() async {
    if (_cachedActiveProfileId != null) return _cachedActiveProfileId!;
    var activeId = await _hiveService.getActiveProfileId();
    if (activeId == null) {
      final profiles = await _hiveService.getProfiles();
      if (profiles.isNotEmpty) {
        activeId = profiles.first.id;
        await _hiveService.setActiveProfileId(activeId);
      } else {
        activeId = 'default_profile';
      }
    }
    _cachedActiveProfileId = activeId;
    return activeId;
  }

  Future<UserProgress> getProgress() async {
    if (_cachedProgress != null) return _cachedProgress!;
    final activeId = await _getActiveProfileId();
    _cachedProgress = await _hiveService.getProgress(activeId);
    return _cachedProgress!;
  }

  Future<void> saveProgress(UserProgress progress) async {
    _cachedProgress = progress;
    final activeId = await _getActiveProfileId();
    await _hiveService.saveProgress(activeId, progress);
  }

  Future<void> completeLevel(int levelNumber, int moves) async {
    final current = await getProgress();
    final updated = current.completeLevel(levelNumber).addMoves(moves);
    await saveProgress(updated);
  }

  Future<void> addRandomLevelMoves(int moves) async {
    final current = await getProgress();
    final updated = current.addMoves(moves);
    await saveProgress(updated);
  }

  Future<void> resetProgress() async {
    _cachedProgress = null;
    final activeId = await _getActiveProfileId();
    await _hiveService.clearProgress(activeId);
  }

  bool isTimerEnabled() {
    return _hiveService.isTimerEnabled();
  }

  Future<void> setTimerEnabled(bool enabled) async {
    await _hiveService.setTimerEnabled(enabled);
  }

  Future<List<UserProfile>> getProfiles() async {
    return _hiveService.getProfiles();
  }

  Future<UserProfile?> getActiveProfile() async {
    final activeId = await _getActiveProfileId();
    final profiles = await getProfiles();
    for (final profile in profiles) {
      if (profile.id == activeId) {
        return profile;
      }
    }
    return null;
  }

  Future<void> createProfile(String name, String emoji) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final profile = UserProfile(
      id: id,
      name: name,
      createdAt: DateTime.now(),
      avatarEmoji: emoji,
    );
    await _hiveService.saveProfile(profile);
    await switchProfile(id);
  }

  Future<void> switchProfile(String profileId) async {
    _cachedActiveProfileId = profileId;
    _cachedProgress = null;
    await _hiveService.setActiveProfileId(profileId);
  }

  Future<void> deleteProfile(String profileId) async {
    await _hiveService.deleteProfile(profileId);
    if (_cachedActiveProfileId == profileId) {
      _cachedActiveProfileId = null;
      _cachedProgress = null;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _hiveService.saveProfile(profile);
  }
}
