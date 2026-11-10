// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Psito Mines';

  @override
  String get newGame => 'Novo jogo';

  @override
  String get youWon => 'Você achou todos!';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get caught => 'Um gato te pegou!';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String winSummary(String time) {
    return 'Todos os gatos achados em $time';
  }

  @override
  String get yourName => 'Seu nome';

  @override
  String get save => 'Salvar';

  @override
  String get skip => 'Pular';

  @override
  String get bestGames => 'Melhores partidas';

  @override
  String get noScores => 'Nenhuma partida vencida ainda.';

  @override
  String get close => 'Fechar';

  @override
  String get statCats => 'Gatos';

  @override
  String get statTime => 'Tempo';

  @override
  String get moreOptions => 'Mais opções';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Médio';

  @override
  String get hard => 'Difícil';

  @override
  String difficultyDetail(String name, int width, int height, int cats) {
    return '$name: $width × $height, $cats gatos';
  }

  @override
  String get howToPlay => 'Como jogar';

  @override
  String get about => 'Sobre';

  @override
  String get howToPlayBody =>
      'Alguns gatos estão escondidos sob as folhas. Levante todas as folhas que não têm gato embaixo.\n\nUm clique levanta uma folha, e a primeira é sempre segura. Um número diz quantos gatos há nas oito folhas em volta dele.\n\nO botão direito, ou segurar o clique, põe uma pena na folha suspeita, e uma folha com pena não se levanta sem querer.\n\nUm clique num número levanta as folhas em volta quando as penas ali somam aquele número. Se uma pena estiver no lugar errado, o gato escapa.\n\nCtrl+N começa um novo jogo.';

  @override
  String get aboutBody =>
      'Encontre os gatos escondidos sob as folhas, com calopsitas. Sem anúncios, sem telemetria e sem conta.';

  @override
  String get aboutLegal => 'Código sob a licença Apache 2.0. Arte sob CC0.';

  @override
  String cellLeaf(int row, int column) {
    return 'Folha, linha $row, coluna $column';
  }

  @override
  String cellFeather(int row, int column) {
    return 'Folha com pena, linha $row, coluna $column';
  }

  @override
  String cellCat(int row, int column) {
    return 'Gato, linha $row, coluna $column';
  }

  @override
  String cellOpen(int count, int row, int column) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gatos por perto',
      one: '1 gato por perto',
      zero: 'Nenhum gato por perto',
    );
    return '$_temp0, linha $row, coluna $column';
  }
}
