import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_mines/l10n/app_localizations.dart';
import 'package:psito_mines/src/game/game_controller.dart';
import 'package:psito_mines/src/game/game_state.dart';
import 'package:psito_mines/src/game/scores.dart';
import 'package:psito_mines/src/ui/board.dart';
import 'package:psito_mines/src/ui/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget app(Widget home) => MaterialApp(
  locale: const Locale('pt'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

Future<void> pumpGame(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(app(const GameScreen(number: 3)));
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> finish(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

Finder cell(int index) => find.byKey(ValueKey('cell-$index'));

GameState garden(Set<int> cats, {Set<int> open = const {}}) => GameState(
  difficulty: Difficulty.easy,
  seed: 1,
  cats: cats,
  open: open,
);

Future<GameController> pumpBoard(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final game = GameController(number: 1);
  addTearDown(game.dispose);
  await tester.pumpWidget(app(Scaffold(body: Board(game: game))));
  await tester.pump();
  return game;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('a click lifts a leaf', (tester) async {
    final game = await pumpBoard(tester);
    await tester.tap(cell(40));
    await tester.pump(const Duration(seconds: 1));
    expect(game.state.open.contains(40), isTrue);
    expect(game.state.isLost, isFalse);
    await finish(tester);
  });

  testWidgets('the right button puts a feather', (tester) async {
    final game = await pumpBoard(tester);
    await tester.tap(cell(10), buttons: kSecondaryMouseButton);
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.state.flags, {10});
    await finish(tester);
  });

  testWidgets('every leaf has a name for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    final game = await pumpBoard(tester);
    game
      ..state = garden({0}, open: {1})
      ..flag(80)
      ..flag(80);
    await tester.pump(const Duration(seconds: 1));
    expect(find.bySemanticsLabel('Folha, linha 1, coluna 1'), findsOneWidget);
    expect(
      find.bySemanticsLabel('1 gato por perto, linha 1, coluna 2'),
      findsOneWidget,
    );
    handle.dispose();
    await finish(tester);
  });

  testWidgets('the winner saves a name and sees the best games', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final board = tester.widget<Board>(find.byType(Board));
    board.game.state = garden({0});
    board.game.tap(80);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Você achou todos!'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ana');
    await tester.pump();
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Melhores partidas'), findsOneWidget);
    expect((await const ScoreStore().load(Difficulty.easy)).single.name, 'Ana');
    await finish(tester);
  });

  testWidgets('a cat ends the game and a new one can start', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = garden({0, 80});
    game.tap(0);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Um gato te pegou!'), findsOneWidget);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Um gato te pegou!'), findsNothing);
    expect(game.state.started, isFalse);
    await finish(tester);
  });

  testWidgets('the difficulty menu changes the garden', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    await tester.tap(find.text('Fácil'));
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    await tester.tap(find.textContaining('Difícil'));
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    final game = tester.widget<Board>(find.byType(Board)).game;
    expect(game.difficulty, Difficulty.hard);
    expect(cell(Difficulty.hard.cells - 1), findsOneWidget);
    expect(await const ScoreStore().lastDifficulty(), Difficulty.hard);
    await finish(tester);
  });

  testWidgets('fits small and large windows without overflowing', (tester) async {
    for (final size in const [Size(480, 360), Size(1920, 1080), Size(800, 1200)]) {
      await pumpGame(tester, size);
      final game = tester.widget<Board>(find.byType(Board)).game;
      for (final difficulty in Difficulty.values) {
        game.newGame(difficulty);
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
      }
    }
    await finish(tester);
  });
}
