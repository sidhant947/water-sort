import 'package:watersort/domain/models/user_progress.dart';
import '../services/hive_service.dart';

class ProgressRepository {
  ProgressRepository({required this._hiveService});

  final HiveService _hiveService;
  UserProgress? _cachedProgress;

  Future<UserProgress> getProgress() async {
    if (_cachedProgress != null) return _cachedProgress!;
    _cachedProgress = await _hiveService.getProgress();
    return _cachedProgress!;
  }

  Future<void> saveProgress(UserProgress progress) async {
    _cachedProgress = progress;
    await _hiveService.saveProgress(progress);
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
    await _hiveService.clearProgress();
  }
}
