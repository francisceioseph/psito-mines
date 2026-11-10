// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get youWon => 'Du hast alle gefunden!';

  @override
  String get caught => 'Eine Katze hat dich erwischt!';

  @override
  String get tryAgain => 'Nochmal versuchen';

  @override
  String winSummary(String time) {
    return 'Alle Katzen gefunden in $time';
  }

  @override
  String get statCats => 'Katzen';

  @override
  String get easy => 'Leicht';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name: $width × $height, $cats Katzen';
  }

  @override
  String get howToPlayBody =>
      'Unter den Blättern verstecken sich Katzen. Hebe jedes Blatt hoch, unter dem keine Katze ist.\n\nEin Klick hebt ein Blatt, und das erste ist immer sicher. Eine Zahl sagt, wie viele Katzen unter den acht Blättern um sie herum sind.\n\nDie rechte Maustaste oder ein langer Klick legt eine Feder auf ein verdächtiges Blatt, und ein Blatt mit Feder lässt sich nicht aus Versehen heben.\n\nEin Klick auf eine Zahl hebt die Blätter um sie herum, wenn die Federn dort genau diese Zahl ergeben. Liegt eine Feder falsch, entwischt die Katze.\n\nStrg+N startet ein neues Spiel.';

  @override
  String get aboutBody =>
      'Finde die Katzen unter den Blättern, mit Nymphensittichen. Ohne Werbung, ohne Telemetrie und ohne Konto.';

  @override
  String get aboutLegal =>
      'Code unter der Apache-2.0-Lizenz. Grafiken unter CC0.';

  @override
  String cellLeaf(int row, int column) {
    return 'Blatt, Zeile $row, Spalte $column';
  }

  @override
  String cellFeather(int row, int column) {
    return 'Blatt mit Feder, Zeile $row, Spalte $column';
  }

  @override
  String cellCat(int row, int column) {
    return 'Katze, Zeile $row, Spalte $column';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Katzen in der Nähe',
      one: '1 Katze in der Nähe',
      zero: 'Keine Katze in der Nähe',
    );
    return '$_temp0, Zeile $row, Spalte $column';
  }
}
