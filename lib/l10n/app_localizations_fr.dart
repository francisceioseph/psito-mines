// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get youWon => 'Vous les avez tous trouvés !';

  @override
  String get caught => 'Un chat vous a attrapé !';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String winSummary(String time) {
    return 'Tous les chats trouvés en $time';
  }

  @override
  String get statCats => 'Chats';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name : $width × $height, $cats chats';
  }

  @override
  String get howToPlayBody =>
      'Des chats se cachent sous les feuilles. Soulevez toutes les feuilles qui ne cachent pas de chat.\n\nUn clic soulève une feuille, et la première est toujours sûre. Un nombre indique combien de chats se trouvent dans les huit feuilles qui l’entourent.\n\nLe bouton droit, ou un clic maintenu, pose une plume sur une feuille suspecte, et une feuille avec une plume ne se soulève pas par erreur.\n\nUn clic sur un nombre soulève les feuilles autour quand les plumes posées là font ce nombre. Si une plume est mal placée, le chat s’échappe.\n\nCtrl+N lance une nouvelle partie.';

  @override
  String get aboutBody =>
      'Trouvez les chats cachés sous les feuilles, avec des calopsittes. Sans publicité, sans télémétrie et sans compte.';

  @override
  String get aboutLegal =>
      'Code sous licence Apache 2.0. Illustrations sous CC0.';

  @override
  String cellLeaf(int row, int column) {
    return 'Feuille, ligne $row, colonne $column';
  }

  @override
  String cellFeather(int row, int column) {
    return 'Feuille avec une plume, ligne $row, colonne $column';
  }

  @override
  String cellCat(int row, int column) {
    return 'Chat, ligne $row, colonne $column';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chats autour',
      one: '1 chat autour',
      zero: 'Aucun chat autour',
    );
    return '$_temp0, ligne $row, colonne $column';
  }
}
