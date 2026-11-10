// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get newGame => 'New game';

  @override
  String get youWon => 'You found them all!';

  @override
  String get playAgain => 'Play again';

  @override
  String get caught => 'A cat caught you!';

  @override
  String get tryAgain => 'Try again';

  @override
  String winSummary(String time) {
    return 'Every cat found in $time';
  }

  @override
  String get yourName => 'Your name';

  @override
  String get save => 'Save';

  @override
  String get skip => 'Skip';

  @override
  String get bestGames => 'Best games';

  @override
  String get noScores => 'No games won yet.';

  @override
  String get close => 'Close';

  @override
  String get statCats => 'Cats';

  @override
  String get statTime => 'Time';

  @override
  String get moreOptions => 'More options';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name: $width × $height, $cats cats';
  }

  @override
  String get howToPlay => 'How to play';

  @override
  String get about => 'About';

  @override
  String get howToPlayBody =>
      'Some cats are hiding under the leaves. Lift every leaf that has no cat under it.\n\nA click lifts a leaf, and the first one is always safe. A number tells how many cats are in the eight leaves around it.\n\nThe right button, or holding the click, puts a feather on a leaf you suspect, and a leaf with a feather cannot be lifted by accident.\n\nA click on a number lifts the leaves around it when the feathers there add up to that number. If a feather is in the wrong place, the cat gets out.\n\nCtrl+N starts a new game.';

  @override
  String get aboutBody =>
      'Find the cats hiding under the leaves, with cockatiels. No ads, no telemetry and no account.';

  @override
  String get aboutLegal => 'Code under the Apache 2.0 license. Art under CC0.';

  @override
  String cellLeaf(int row, int column) {
    return 'Leaf, row $row, column $column';
  }

  @override
  String cellFeather(int row, int column) {
    return 'Leaf with a feather, row $row, column $column';
  }

  @override
  String cellCat(int row, int column) {
    return 'Cat, row $row, column $column';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cats nearby',
      one: '1 cat nearby',
      zero: 'No cats nearby',
    );
    return '$_temp0, row $row, column $column';
  }
}
