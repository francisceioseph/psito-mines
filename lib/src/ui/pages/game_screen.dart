import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import '../../../l10n/l10n.dart';
import '../../game/game_controller.dart';
import '../../game/scores.dart';
import '../atoms/tile.dart';
import '../organisms/board.dart';
import '../organisms/mines_bar.dart';
import '../organisms/victory_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.number});

  /// A fixed game number. Without one, the cats hide at random.
  final int? number;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _game = GameController(number: widget.number);
  final _peek = PeekController();
  bool _precached = false;
  bool _wasOver = false;

  @override
  void initState() {
    super.initState();
    _game.addListener(_gameChanged);
    const ScoreStore().lastDifficulty().then((difficulty) {
      if (mounted && difficulty != _game.difficulty && !_game.state.started) {
        _game.newGame(difficulty);
      }
    });
  }

  /// The cockatiel comes to see how the game ended.
  void _gameChanged() {
    final over = _game.state.isOver;
    if (over && !_wasOver) _peek.peekNow();
    _wasOver = over;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    for (final path in allTileArt()) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _game.dispose();
    _peek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GameTable(
    peek: _peek,
    shortcuts: {
      const SingleActivator(LogicalKeyboardKey.keyN, control: true):
          _game.newGame,
    },
    bar: ListenableBuilder(
      listenable: _game,
      builder: (context, _) => MinesBar(game: _game),
    ),
    board: Board(game: _game),
    overlays: [_EndOfGame(game: _game)],
  );
}

/// The panel of a won game, or the note of a lost one.
class _EndOfGame extends StatelessWidget {
  const _EndOfGame({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: game,
    builder: (context, _) {
      final state = game.state;
      if (state.isWon) {
        return Center(
          child: VictoryPanel(
            key: ValueKey(game.gameId),
            game: game,
            store: const ScoreStore(),
          ),
        );
      }
      if (state.isLost) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: EndNote(
              message: context.l10n.caught,
              action: context.l10n.tryAgain,
              onAction: game.newGame,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}
