import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watersort/domain/models/tube.dart';
import 'package:watersort/domain/use_cases/level_solver.dart';

void main() {
  final solvable = [
    const Tube(colors: [Colors.red, Colors.blue], capacity: 2),
    const Tube(colors: [Colors.blue, Colors.red], capacity: 2),
    const Tube(colors: [], capacity: 2),
  ];

  test('check returns a solution without changing the board', () {
    final result = LevelSolver.checkTask(solvable);
    expect(result.status, SolvabilityStatus.solvable);
    expect(result.moves, isNotEmpty);
    expect(solvable.first.colors, [Colors.red, Colors.blue]);
    expect(LevelSolver.solveTask(solvable), isNotEmpty);
  });

  test('exhausted search differs from a deadlocked board', () {
    final solver = LevelSolver();
    final limited = solver.solveDetailed(solvable, maxVisited: 1);
    expect(limited.status, SolvabilityStatus.inconclusive);
    expect(limited.moves, isNull);
    final deadlocked = solver.solveDetailed(solvable.take(2).toList());
    expect(deadlocked.status, SolvabilityStatus.unsolvable);
    expect(deadlocked.moves, isNull);
  });

  test('completed board is solvable even with no search budget', () {
    final result = LevelSolver().solveDetailed([
      const Tube(colors: [Colors.red, Colors.red], capacity: 2),
      const Tube(colors: [], capacity: 2),
    ], maxVisited: 0);
    expect(result.status, SolvabilityStatus.solvable);
    expect(result.moves, isEmpty);
  });
}
