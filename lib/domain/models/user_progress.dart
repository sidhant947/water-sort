import 'package:flutter/material.dart';

@immutable
class UserProgress {
  const UserProgress({
    this.currentLevel = 1,
    this.highestLevelCompleted = 0,
    this.totalMoves = 0,
  });

  final int currentLevel;
  final int highestLevelCompleted;
  final int totalMoves;

  UserProgress copyWith({
    int? currentLevel,
    int? highestLevelCompleted,
    int? totalMoves,
  }) {
    return UserProgress(
      currentLevel: currentLevel ?? this.currentLevel,
      highestLevelCompleted:
          highestLevelCompleted ?? this.highestLevelCompleted,
      totalMoves: totalMoves ?? this.totalMoves,
    );
  }

  UserProgress completeLevel(int levelNumber) {
    final newHighest = levelNumber > highestLevelCompleted ? levelNumber : highestLevelCompleted;
    final newCurrent = levelNumber >= currentLevel ? levelNumber + 1 : currentLevel;
    return UserProgress(
      currentLevel: newCurrent,
      highestLevelCompleted: newHighest,
      totalMoves: totalMoves,
    );
  }

  UserProgress addMoves(int moves) {
    return copyWith(totalMoves: totalMoves + moves);
  }
}
