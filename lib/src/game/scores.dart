import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_state.dart';

/// A won game. The quicker, the better.
@immutable
class Score {
  const Score({required this.name, required this.seconds, required this.game});

  factory Score.fromJson(Map<String, dynamic> json) => Score(
    name: json['name'] as String,
    seconds: json['seconds'] as int,
    game: json['game'] as int,
  );

  final String name;
  final int seconds;
  final int game;

  Map<String, dynamic> toJson() => {
    'name': name,
    'seconds': seconds,
    'game': game,
  };
}

const maxScores = 10;

/// The list with [score] in its place, keeping only the best ones.
List<Score> insertScore(List<Score> scores, Score score) {
  final sorted = [...scores, score]
    ..sort((a, b) => a.seconds.compareTo(b.seconds));
  return sorted.take(maxScores).toList();
}

/// The scores of each difficulty, the last name used and the last difficulty
/// played. They stay on this computer.
class ScoreStore {
  const ScoreStore();

  static const _nameKey = 'player_name';
  static const _difficultyKey = 'difficulty';

  static String _scoresKey(Difficulty difficulty) =>
      'scores_${difficulty.name}';

  Future<List<Score>> load(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_scoresKey(difficulty));
    if (raw == null) return const [];
    try {
      return [
        for (final item in jsonDecode(raw) as List)
          Score.fromJson(item as Map<String, dynamic>),
      ];
    } on Object {
      // A damaged file must not stop the game.
      return const [];
    }
  }

  Future<void> save(Difficulty difficulty, List<Score> scores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scoresKey(difficulty), jsonEncode(scores));
  }

  Future<String> lastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? '';
  }

  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  Future<Difficulty> lastDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_difficultyKey);
    return Difficulty.values.firstWhere(
      (difficulty) => difficulty.name == name,
      orElse: () => Difficulty.easy,
    );
  }

  Future<void> saveDifficulty(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty.name);
  }
}
