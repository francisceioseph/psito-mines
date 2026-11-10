// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get youWon => 'Вы нашли всех!';

  @override
  String get caught => 'Вас поймала кошка!';

  @override
  String get tryAgain => 'Ещё раз';

  @override
  String winSummary(String time) {
    return 'Все кошки найдены за $time';
  }

  @override
  String get statCats => 'Кошки';

  @override
  String get easy => 'Лёгкий';

  @override
  String get medium => 'Средний';

  @override
  String get hard => 'Сложный';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name: $width × $height, кошек: $cats';
  }

  @override
  String get howToPlayBody =>
      'Под листьями прячутся кошки. Поднимите все листья, под которыми нет кошки.\n\nЩелчок поднимает лист, и первый всегда безопасен. Число показывает, сколько кошек под восемью листьями вокруг него.\n\nПравая кнопка или долгое нажатие кладёт перо на подозрительный лист, и лист с пером нельзя поднять случайно.\n\nЩелчок по числу поднимает листья вокруг, когда перьев рядом столько же, сколько показывает число. Если перо лежит не там, кошка убегает.\n\nCtrl+N начинает новую игру.';

  @override
  String get aboutBody =>
      'Найдите кошек, спрятавшихся под листьями, вместе с кореллами. Без рекламы, без телеметрии и без учётной записи.';

  @override
  String get aboutLegal => 'Код под лицензией Apache 2.0. Рисунки под CC0.';

  @override
  String cellLeaf(int row, int column) {
    return 'Лист, строка $row, столбец $column';
  }

  @override
  String cellFeather(int row, int column) {
    return 'Лист с пером, строка $row, столбец $column';
  }

  @override
  String cellCat(int row, int column) {
    return 'Кошка, строка $row, столбец $column';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рядом $count кошек',
      few: 'Рядом $count кошки',
      one: 'Рядом $count кошка',
      zero: 'Рядом нет кошек',
    );
    return '$_temp0, строка $row, столбец $column';
  }
}
