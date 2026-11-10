import 'dart:math';

import 'package:flutter/foundation.dart';

import 'game_state.dart';

/// A game in progress: the garden and the clock.
class GameController extends ChangeNotifier {
  GameController({this.difficulty = Difficulty.easy, int? number})
    : number = number ?? _randomNumber() {
    state = GameState(difficulty: difficulty, seed: this.number);
  }

  static int _randomNumber() => Random().nextInt(999999) + 1;

  Difficulty difficulty;
  int number;
  late GameState state;

  /// Changes with each new game, so that nothing carries over to the next.
  int gameId = 0;

  /// The leaf of the latest click, where the opening starts to spread from.
  int? origin;

  final Stopwatch _clock = Stopwatch();

  /// The time played, from the first leaf until the end of the game.
  int get seconds => _clock.elapsed.inSeconds;

  void newGame([Difficulty? next]) {
    difficulty = next ?? difficulty;
    number = _randomNumber();
    state = GameState(difficulty: difficulty, seed: number);
    gameId++;
    origin = null;
    _clock
      ..stop()
      ..reset();
    notifyListeners();
  }

  /// A click: lifts the leaf, or tries the leaves around a number.
  void tap(int cell) {
    final next = state.open.contains(cell)
        ? state.chord(cell)
        : state.reveal(cell);
    if (next == null) return;
    state = next;
    origin = cell;
    if (state.isOver) {
      _clock.stop();
    } else {
      _clock.start();
    }
    notifyListeners();
  }

  /// A click with the right button: puts a feather on the leaf or takes it.
  void flag(int cell) {
    final next = state.toggleFlag(cell);
    if (next == null) return;
    state = next;
    notifyListeners();
  }
}
