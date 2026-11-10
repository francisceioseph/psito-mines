// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get youWon => '全部找到了！';

  @override
  String get caught => '被猫抓住了！';

  @override
  String get tryAgain => '再试一次';

  @override
  String winSummary(String time) {
    return '用时 $time 找到所有的猫';
  }

  @override
  String get statCats => '猫';

  @override
  String get easy => '简单';

  @override
  String get medium => '中等';

  @override
  String get hard => '困难';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name：$width × $height，$cats 只猫';
  }

  @override
  String get howToPlayBody =>
      '有些猫藏在树叶下面。掀开所有下面没有猫的树叶。\n\n单击掀开一片树叶，第一片总是安全的。数字表示它周围八片树叶下有几只猫。\n\n右键或长按会在可疑的树叶上放一根羽毛，放了羽毛的树叶不会被误掀。\n\n当数字周围的羽毛数正好等于这个数字时，单击它会掀开周围的树叶。如果羽毛放错了地方，猫就会跑出来。\n\nCtrl+N 开始新游戏。';

  @override
  String get aboutBody => '和玄凤鹦鹉一起，找出藏在树叶下的猫。没有广告，没有遥测，也不需要账号。';

  @override
  String get aboutLegal => '代码采用 Apache 2.0 许可证。美术采用 CC0。';

  @override
  String cellLeaf(int row, int column) {
    return '树叶，第 $row 行，第 $column 列';
  }

  @override
  String cellFeather(int row, int column) {
    return '有羽毛的树叶，第 $row 行，第 $column 列';
  }

  @override
  String cellCat(int row, int column) {
    return '猫，第 $row 行，第 $column 列';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '附近有 $count 只猫',
      zero: '附近没有猫',
    );
    return '$_temp0，第 $row 行，第 $column 列';
  }
}
