import 'package:flutter_test/flutter_test.dart';
import 'package:psito_mines/src/game/game_controller.dart';
import 'package:psito_mines/src/game/game_state.dart';
import 'package:psito_mines/src/game/scores.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An easy garden with cats only where it is told to have them.
GameState garden(Set<int> cats, {Set<int> open = const {}, Set<int> flags = const {}}) =>
    GameState(
      difficulty: Difficulty.easy,
      seed: 1,
      cats: cats,
      open: open,
      flags: flags,
    );

void main() {
  group('first click', () {
    test('hides the right number of cats, and none near the click', () {
      for (final difficulty in Difficulty.values) {
        for (var seed = 1; seed < 40; seed++) {
          final start = GameState(difficulty: difficulty, seed: seed);
          final state = start.reveal(difficulty.cells ~/ 2)!;
          expect(state.cats.length, difficulty.cats);
          expect(state.isLost, isFalse);
          expect(state.cats.contains(difficulty.cells ~/ 2), isFalse);
          for (final near in start.neighbours(difficulty.cells ~/ 2)) {
            expect(state.cats.contains(near), isFalse);
          }
        }
      }
    });

    test('the same number and click give the same garden', () {
      GameState play(int seed) =>
          GameState(difficulty: Difficulty.medium, seed: seed).reveal(5)!;
      expect(play(9).cats, play(9).cats);
      expect(play(9).cats, isNot(play(10).cats));
    });
  });

  test('neighbours stop at the borders', () {
    final state = garden(const {});
    expect(state.neighbours(0).toSet(), {1, 9, 10});
    expect(state.neighbours(8).toSet(), {7, 16, 17});
    expect(state.neighbours(40).length, 8);
    expect(state.neighbours(80).toSet(), {70, 71, 79});
  });

  group('reveal', () {
    test('a leaf near a cat opens alone', () {
      final state = garden({0}).reveal(1)!;
      expect(state.open, {1});
      expect(state.catsAround(1), 1);
    });

    test('a leaf far from any cat spreads up to the numbers', () {
      final state = garden({0}).reveal(80)!;
      expect(state.open.contains(40), isTrue);
      expect(state.open.contains(1), isTrue);
      expect(state.open.contains(0), isFalse);
    });

    test('the spread goes around the feathers', () {
      final state = garden({0}, flags: {40}).reveal(80)!;
      expect(state.open.contains(40), isFalse);
      expect(state.flags, {40});
    });

    test('a feather protects the leaf', () {
      expect(garden({0}, flags: {0}).reveal(0), isNull);
    });

    test('a cat ends the game and nothing else can be done', () {
      final state = garden({0, 80}).reveal(0)!;
      expect(state.isLost, isTrue);
      expect(state.caughtAt, 0);
      expect(state.reveal(40), isNull);
      expect(state.toggleFlag(40), isNull);
    });

    test('opening everything without a cat wins and marks the cats', () {
      final state = garden({0}).reveal(80)!;
      expect(state.isWon, isTrue);
      expect(state.flags, {0});
      expect(state.catsLeft, Difficulty.easy.cats - 1);
    });
  });

  group('feathers', () {
    test('go on and off and count down the cats', () {
      final on = garden({0}).toggleFlag(5)!;
      expect(on.catsLeft, Difficulty.easy.cats - 1);
      expect(on.toggleFlag(5)!.flags, isEmpty);
    });

    test('do not go on an open leaf', () {
      expect(garden({0}, open: {5}).toggleFlag(5), isNull);
    });
  });

  group('chord', () {
    test('lifts the leaves around when the feathers add up', () {
      final state = garden({0, 80}, open: {1}, flags: {0}).chord(1)!;
      expect(state.open.containsAll({2, 9, 10, 11}), isTrue);
      expect(state.isLost, isFalse);
    });

    test('does nothing when they do not add up', () {
      expect(garden({0}, open: {1}).chord(1), isNull);
    });

    test('a feather in the wrong place lets the cat out', () {
      final state = garden({0, 80}, open: {1}, flags: {2}).chord(1)!;
      expect(state.isLost, isTrue);
      expect(state.caughtAt, 0);
    });
  });

  group('controller', () {
    test('a new game can change the difficulty and forgets the last', () {
      final game = GameController(number: 3);
      game.tap(40);
      final id = game.gameId;
      game.newGame(Difficulty.hard);
      expect(game.state.difficulty, Difficulty.hard);
      expect(game.state.started, isFalse);
      expect(game.gameId, id + 1);
      expect(game.origin, isNull);
    });

    test('a click on a number tries the leaves around it', () {
      final game = GameController(number: 3);
      game.state = garden({0, 80}, open: {1}, flags: {0});
      game.tap(1);
      expect(game.state.open.contains(2), isTrue);
    });
  });

  group('scores', () {
    Score score(String name, int seconds) =>
        Score(name: name, seconds: seconds, game: 1);

    test('the quickest come first and only the ten best stay', () {
      var scores = <Score>[];
      for (var i = 12; i > 0; i--) {
        scores = insertScore(scores, score('$i', i));
      }
      expect(scores.length, maxScores);
      expect(scores.first.name, '1');
      expect(scores.last.name, '10');
    });

    test('each difficulty keeps its own and a damaged file is ignored', () async {
      SharedPreferences.setMockInitialValues({});
      const store = ScoreStore();
      await store.save(Difficulty.hard, [score('Ana', 90)]);
      expect((await store.load(Difficulty.hard)).single.name, 'Ana');
      expect(await store.load(Difficulty.easy), isEmpty);

      SharedPreferences.setMockInitialValues({'scores_easy': 'not json'});
      expect(await store.load(Difficulty.easy), isEmpty);
    });

    test('the difficulty is remembered', () async {
      SharedPreferences.setMockInitialValues({});
      const store = ScoreStore();
      expect(await store.lastDifficulty(), Difficulty.easy);
      await store.saveDifficulty(Difficulty.medium);
      expect(await store.lastDifficulty(), Difficulty.medium);
    });
  });
}
