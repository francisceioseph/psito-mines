import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

enum Difficulty {
  easy(9, 9, 10),
  medium(16, 16, 40),
  hard(30, 16, 99);

  const Difficulty(this.width, this.height, this.cats);

  final int width;
  final int height;
  final int cats;

  int get cells => width * height;
}

/// A garden of leaves with cats under some of them.
///
/// Cells are numbered row by row. The cats only hide after the first click,
/// so the first leaf is always safe, and so are the ones around it.
@immutable
class GameState {
  const GameState({
    required this.difficulty,
    required this.seed,
    this.cats = const {},
    this.open = const {},
    this.flags = const {},
    this.caughtAt,
  });

  final Difficulty difficulty;
  final int seed;
  final Set<int> cats;
  final Set<int> open;
  final Set<int> flags;

  /// The leaf that hid the cat that ended the game.
  final int? caughtAt;

  bool get started => cats.isNotEmpty;
  bool get isLost => caughtAt != null;
  bool get isWon =>
      started && !isLost && open.length == difficulty.cells - cats.length;
  bool get isOver => isLost || isWon;

  /// Can go below zero: nothing stops a player from marking too many leaves.
  int get catsLeft => difficulty.cats - flags.length;

  Iterable<int> neighbours(int cell) sync* {
    final width = difficulty.width;
    final x = cell % width;
    final y = cell ~/ width;
    for (var ny = max(0, y - 1); ny <= min(difficulty.height - 1, y + 1); ny++) {
      for (var nx = max(0, x - 1); nx <= min(width - 1, x + 1); nx++) {
        if (nx != x || ny != y) yield ny * width + nx;
      }
    }
  }

  /// How many cats are around [cell].
  int catsAround(int cell) => _around(cats, cell);

  int _around(Set<int> within, int cell) =>
      neighbours(cell).where(within.contains).length;

  Set<int> _hideCats(int first) {
    final safe = {first, ...neighbours(first)};
    final places = [
      for (var cell = 0; cell < difficulty.cells; cell++)
        if (!safe.contains(cell)) cell,
    ]..shuffle(Random(seed));
    return places.take(difficulty.cats).toSet();
  }

  /// Lifts a leaf and, when no cat is near, all the leaves connected to it.
  /// Null when the leaf cannot be lifted.
  GameState? reveal(int cell) {
    if (isOver || open.contains(cell) || flags.contains(cell)) return null;
    final hidden = started ? cats : _hideCats(cell);
    if (hidden.contains(cell)) {
      return _with(cats: hidden, caughtAt: cell);
    }
    final opened = {...open};
    final queue = Queue<int>.of([cell]);
    while (queue.isNotEmpty) {
      final next = queue.removeFirst();
      if (!opened.add(next) || _around(hidden, next) != 0) continue;
      queue.addAll(
        neighbours(next).where(
          (n) => !opened.contains(n) && !flags.contains(n),
        ),
      );
    }
    final won = opened.length == difficulty.cells - hidden.length;
    return _with(cats: hidden, open: opened, flags: won ? hidden : flags);
  }

  /// Marks a leaf with a feather, or takes the feather back.
  GameState? toggleFlag(int cell) {
    if (isOver || open.contains(cell)) return null;
    return _with(
      flags: flags.contains(cell)
          ? ({...flags}..remove(cell))
          : {...flags, cell},
    );
  }

  /// A click on a number: when the feathers around it add up, lifts the other
  /// leaves. A feather in the wrong place lets the cat out.
  GameState? chord(int cell) {
    if (isOver || !open.contains(cell)) return null;
    if (_around(flags, cell) != catsAround(cell)) return null;
    final others = neighbours(cell)
        .where((n) => !open.contains(n) && !flags.contains(n))
        .toList();
    if (others.isEmpty) return null;
    var state = this;
    for (final other in others) {
      state = state.reveal(other) ?? state;
    }
    return state;
  }

  GameState _with({
    Set<int>? cats,
    Set<int>? open,
    Set<int>? flags,
    int? caughtAt,
  }) => GameState(
    difficulty: difficulty,
    seed: seed,
    cats: cats ?? this.cats,
    open: open ?? this.open,
    flags: flags ?? this.flags,
    caughtAt: caughtAt ?? this.caughtAt,
  );
}
