import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import '../game/scores.dart';
import 'app_bar.dart';
import 'board.dart';
import 'colors.dart';
import 'peek.dart';
import 'victory_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.number});

  /// A fixed game number. Without one, the cats hide at random.
  final int? number;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _idle = Duration(seconds: 45);
  static const _peekTime = Duration(milliseconds: 3200);

  late final GameController _game = GameController(number: widget.number);
  Timer? _timer;
  final _random = Random();
  PeekSpot? _spot;
  bool _peeking = false;
  bool _precached = false;
  bool _wasOver = false;

  @override
  void initState() {
    super.initState();
    _waitIdle();
    _game.addListener(_gameChanged);
    const ScoreStore().lastDifficulty().then((difficulty) {
      if (mounted && difficulty != _game.difficulty && !_game.state.started) {
        _game.newGame(difficulty);
      }
    });
  }

  void _gameChanged() {
    final over = _game.state.isOver;
    if (over && !_wasOver) _peek();
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
    _timer?.cancel();
    _game.dispose();
    super.dispose();
  }

  void _waitIdle() {
    _timer?.cancel();
    _timer = Timer(_idle, _peek);
  }

  void _peek() {
    _timer?.cancel();
    setState(() {
      _spot = nextPeekSpot(_random, _spot);
      _peeking = true;
    });
    _timer = Timer(_peekTime, () {
      setState(() => _peeking = false);
      _waitIdle();
    });
  }

  void _activity() {
    if (_peeking) setState(() => _peeking = false);
    _waitIdle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsitoColors.felt,
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyN, control: true):
              _game.newGame,
        },
        child: Focus(
          autofocus: true,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _activity(),
            child: Column(
              children: [
                ListenableBuilder(
                  listenable: _game,
                  builder: (context, _) => GameAppBar(game: _game),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 1.1,
                            colors: [
                              PsitoColors.feltGlow,
                              PsitoColors.felt,
                              PsitoColors.feltDark,
                            ],
                            stops: [0, .6, 1],
                          ),
                        ),
                      ),
                      Board(game: _game),
                      _EndOfGame(game: _game),
                      if (_spot case final spot?)
                        Peek(
                          key: ObjectKey(spot),
                          spot: spot,
                          visible: _peeking,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
            child: _LostNote(game: game),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}

class _LostNote extends StatelessWidget {
  const _LostNote({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: PsitoColors.cream,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                l10n.caught,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: PsitoColors.black,
                ),
              ),
            ),
            const SizedBox(width: 14),
            FilledButton(
              onPressed: game.newGame,
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
