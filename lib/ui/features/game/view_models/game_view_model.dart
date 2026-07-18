import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:watersort/data/repositories/progress_repository.dart';
import 'package:watersort/domain/models/game_level.dart';
import 'package:watersort/domain/models/tube.dart';
import 'package:watersort/domain/use_cases/level_generator.dart';

@immutable
class MoveSnapshot {
  const MoveSnapshot({required this.tubes, required this.moveCount});
  final List<Tube> tubes;
  final int moveCount;
}

@immutable
class GameViewModelState {
  const GameViewModelState({
    this.level,
    this.isLoading = false,
    this.isComplete = false,
    this.selectedTubeIndex,
    this.pouringFromIndex,
    this.pouringToIndex,
    this.moveCount = 0,
    this.error,
    this.isRandomMode = false,
    this.randomDifficulty,
    this.randomSeed,
    this.moveHistory = const [],
    this.timeLeft,
    this.isTimeOut = false,
    this.isProgressSaved = false,
  });

  final GameLevel? level;
  final bool isLoading;
  final bool isComplete;
  final int? selectedTubeIndex;
  final int? pouringFromIndex;
  final int? pouringToIndex;
  final int moveCount;
  final String? error;
  final bool isRandomMode;
  final String? randomDifficulty;
  final int? randomSeed;
  final List<MoveSnapshot> moveHistory;
  final int? timeLeft;
  final bool isTimeOut;
  final bool isProgressSaved;

  bool get canUndo => moveHistory.isNotEmpty && !isComplete && !isTimeOut;

  GameViewModelState copyWith({
    GameLevel? level,
    bool? isLoading,
    bool? isComplete,
    int? Function()? selectedTubeIndex,
    int? Function()? pouringFromIndex,
    int? Function()? pouringToIndex,
    int? moveCount,
    String? error,
    bool? isRandomMode,
    String? randomDifficulty,
    int? randomSeed,
    List<MoveSnapshot>? moveHistory,
    int? Function()? timeLeft,
    bool? isTimeOut,
    bool? isProgressSaved,
  }) {
    return GameViewModelState(
      level: level ?? this.level,
      isLoading: isLoading ?? this.isLoading,
      isComplete: isComplete ?? this.isComplete,
      selectedTubeIndex:
          selectedTubeIndex != null ? selectedTubeIndex() : this.selectedTubeIndex,
      pouringFromIndex:
          pouringFromIndex != null ? pouringFromIndex() : this.pouringFromIndex,
      pouringToIndex:
          pouringToIndex != null ? pouringToIndex() : this.pouringToIndex,
      moveCount: moveCount ?? this.moveCount,
      error: error,
      isRandomMode: isRandomMode ?? this.isRandomMode,
      randomDifficulty: randomDifficulty ?? this.randomDifficulty,
      randomSeed: randomSeed ?? this.randomSeed,
      moveHistory: moveHistory ?? this.moveHistory,
      timeLeft: timeLeft != null ? timeLeft() : this.timeLeft,
      isTimeOut: isTimeOut ?? this.isTimeOut,
      isProgressSaved: isProgressSaved ?? this.isProgressSaved,
    );
  }
}

class GameViewModel extends StateNotifier<GameViewModelState> {
  GameViewModel({
    required this._progressRepository,
    required this._levelGenerator,
  }) : super(const GameViewModelState());

  final ProgressRepository _progressRepository;
  final LevelGenerator _levelGenerator;

  Timer? _timer;

  bool _shouldHaveTimer({required bool isRandom, required int levelNumber, required String difficulty}) {
    if (isRandom) {
      return difficulty != 'Easy';
    } else {
      return levelNumber >= 4;
    }
  }

  int _calculateTimerDuration(int colorCount) {
    return ((30 + (colorCount * 15)) * 1.5).round();
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    state = state.copyWith(timeLeft: () => seconds, isTimeOut: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft == null || state.timeLeft! <= 0) {
        timer.cancel();
        return;
      }
      final newTime = state.timeLeft! - 1;
      if (newTime == 0) {
        timer.cancel();
        state = state.copyWith(
          timeLeft: () => 0,
          isTimeOut: true,
        );
        HapticFeedback.heavyImpact();
      } else {
        state = state.copyWith(timeLeft: () => newTime);
      }
    });
  }

  Future<void> loadLevel(int levelNumber) async {
    _timer?.cancel();
    state = const GameViewModelState(isLoading: true);

    try {
      final level = _levelGenerator.generate(levelNumber);
      state = GameViewModelState(level: level);

      if (_shouldHaveTimer(isRandom: false, levelNumber: levelNumber, difficulty: '')) {
        _startTimer(_calculateTimerDuration(level.colorCount));
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load level: $e');
    }
  }

  Future<void> loadRandomLevel(String difficulty, {int? seed}) async {
    _timer?.cancel();
    final int levelSeed = seed ?? DateTime.now().millisecondsSinceEpoch;
    state = GameViewModelState(
      isLoading: true,
      isRandomMode: true,
      randomDifficulty: difficulty,
      randomSeed: levelSeed,
    );

    try {
      int colorCount = 3;
      if (difficulty == 'Medium') {
        colorCount = 6;
      } else if (difficulty == 'Hard') {
        colorCount = 9;
      } else if (difficulty == 'Super Hard') {
        colorCount = 12;
      } else if (difficulty == 'Super Duper Hard') {
        colorCount = 16;
      }

      final level = _levelGenerator.generateRandom(
        colorCount: colorCount,
        seed: levelSeed,
      );

      state = state.copyWith(
        level: level,
        isLoading: false,
      );

      if (_shouldHaveTimer(isRandom: true, levelNumber: -1, difficulty: difficulty)) {
        _startTimer(_calculateTimerDuration(level.colorCount));
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load random level: $e',
      );
    }
  }

  bool isValidPour(int fromIndex, int toIndex) {
    if (state.level == null) return false;
    if (fromIndex == toIndex) return false;
    if (fromIndex < 0 || fromIndex >= state.level!.tubes.length) return false;
    if (toIndex < 0 || toIndex >= state.level!.tubes.length) return false;

    final fromTube = state.level!.tubes[fromIndex];
    final toTube = state.level!.tubes[toIndex];

    if (fromTube.isEmpty || toTube.isFull) return false;

    final colorToMove = fromTube.topColor!;
    return toTube.canReceive(colorToMove);
  }

  void selectTube(int index) {
    if (state.isComplete || state.isTimeOut || state.level == null || state.pouringFromIndex != null) return;

    if (state.selectedTubeIndex == null) {
      if (!state.level!.tubes[index].isEmpty) {
        HapticFeedback.lightImpact();
        state = state.copyWith(selectedTubeIndex: () => index);
      }
    } else {
      if (state.selectedTubeIndex == index) {
        HapticFeedback.lightImpact();
        state = state.copyWith(selectedTubeIndex: () => null);
      } else {
        if (isValidPour(state.selectedTubeIndex!, index)) {
          _pourWater(state.selectedTubeIndex!, index);
        } else {
          // If tap on another non-empty tube and we can't pour there, select that one instead
          if (!state.level!.tubes[index].isEmpty) {
            HapticFeedback.lightImpact();
            state = state.copyWith(selectedTubeIndex: () => index);
          } else {
            HapticFeedback.lightImpact();
            state = state.copyWith(selectedTubeIndex: () => null);
          }
        }
      }
    }
  }

  Future<void> _pourWater(int fromIndex, int toIndex) async {
    if (state.level == null) return;

    HapticFeedback.mediumImpact();

    final fromTube = state.level!.tubes[fromIndex];
    final toTube = state.level!.tubes[toIndex];

    final colorToMove = fromTube.topColor!;
    
    int countToMove = 0;
    for (int i = fromTube.colors.length - 1; i >= 0; i--) {
      if (fromTube.colors[i] == colorToMove) {
        countToMove++;
      } else {
        break;
      }
    }

    final availableSpace = toTube.capacity - toTube.colors.length;
    final pourCount = countToMove.clamp(0, availableSpace);

    if (pourCount == 0) {
      state = state.copyWith(
        selectedTubeIndex: () => null,
      );
      return;
    }

    // Save snapshot before pouring
    final snapshot = MoveSnapshot(
      tubes: state.level!.tubes.map((t) => Tube(colors: List<Color>.from(t.colors), capacity: t.capacity)).toList(),
      moveCount: state.moveCount,
    );

    // Set pouring indices for animation
    state = state.copyWith(
      pouringFromIndex: () => fromIndex,
      pouringToIndex: () => toIndex,
    );

    // Transfer water instantly

    final newFromColors = List<Color>.from(fromTube.colors)
      ..removeRange(fromTube.colors.length - pourCount, fromTube.colors.length);
    final newToColors = List<Color>.from(toTube.colors)
      ..addAll(List.filled(pourCount, colorToMove));

    final newTubes = List<Tube>.from(state.level!.tubes);
    newTubes[fromIndex] = fromTube.copyWith(colors: newFromColors);
    newTubes[toIndex] = toTube.copyWith(colors: newToColors);

    final newLevel = state.level!.copyWith(tubes: newTubes);
    final isComplete = newLevel.isComplete;

    if (isComplete) {
      _timer?.cancel();
      HapticFeedback.heavyImpact();
    }

    state = state.copyWith(
      level: newLevel,
      moveCount: state.moveCount + 1,
      selectedTubeIndex: () => null,
      pouringFromIndex: () => null,
      pouringToIndex: () => null,
      isComplete: isComplete,
      moveHistory: [...state.moveHistory, snapshot],
    );

    if (isComplete) {
      await completeLevel();
    }
  }

  Future<void> completeLevel() async {
    if (state.level == null || !state.isComplete || state.isProgressSaved) return;
    state = state.copyWith(isProgressSaved: true);
    if (state.isRandomMode) {
      await _progressRepository.addRandomLevelMoves(state.moveCount);
    } else {
      await _progressRepository.completeLevel(state.level!.levelNumber, state.moveCount);
    }
  }

  void resetLevel() {
    if (state.level != null) {
      if (state.isRandomMode) {
        loadRandomLevel(state.randomDifficulty ?? 'Easy', seed: state.randomSeed);
      } else {
        loadLevel(state.level!.levelNumber);
      }
    }
  }

  void undoMove() {
    if (!state.canUndo || state.level == null) return;

    HapticFeedback.lightImpact();

    final snapshot = state.moveHistory.last;
    final newHistory = List<MoveSnapshot>.from(state.moveHistory)..removeLast();

    state = state.copyWith(
      level: state.level!.copyWith(tubes: snapshot.tubes),
      moveCount: snapshot.moveCount,
      selectedTubeIndex: () => null,
      isComplete: false,
      moveHistory: newHistory,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
