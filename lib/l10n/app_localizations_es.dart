// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get youWon => '¡Los encontraste a todos!';

  @override
  String get caught => '¡Te atrapó un gato!';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String winSummary(String time) {
    return 'Todos los gatos encontrados en $time';
  }

  @override
  String get statCats => 'Gatos';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name: $width × $height, $cats gatos';
  }

  @override
  String get howToPlayBody =>
      'Hay gatos escondidos bajo las hojas. Levanta todas las hojas que no tengan un gato debajo.\n\nUn clic levanta una hoja, y la primera siempre es segura. Un número indica cuántos gatos hay en las ocho hojas que lo rodean.\n\nEl botón derecho, o mantener el clic, pone una pluma en una hoja sospechosa, y una hoja con pluma no se levanta por accidente.\n\nUn clic en un número levanta las hojas de alrededor cuando las plumas que hay allí suman ese número. Si una pluma está en el lugar equivocado, el gato se escapa.\n\nCtrl+N empieza una partida nueva.';

  @override
  String get aboutBody =>
      'Encuentra los gatos escondidos bajo las hojas, con cacatúas ninfa. Sin anuncios, sin telemetría y sin cuenta.';

  @override
  String get aboutLegal => 'Código bajo la licencia Apache 2.0. Arte bajo CC0.';

  @override
  String cellLeaf(int row, int column) {
    return 'Hoja, fila $row, columna $column';
  }

  @override
  String cellFeather(int row, int column) {
    return 'Hoja con pluma, fila $row, columna $column';
  }

  @override
  String cellCat(int row, int column) {
    return 'Gato, fila $row, columna $column';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gatos cerca',
      one: '1 gato cerca',
      zero: 'Ningún gato cerca',
    );
    return '$_temp0, fila $row, columna $column';
  }
}
