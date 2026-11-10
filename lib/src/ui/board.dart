import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import '../game/game_state.dart';
import 'colors.dart';

const _tiles = 'assets/tiles';
const _maxCell = 52.0;
const _framePadding = 8.0;
const _margin = 12.0;

Iterable<String> allTileArt() => [
  '$_tiles/leaf.png',
  '$_tiles/open.png',
  '$_tiles/caught.png',
  '$_tiles/cat.png',
  '$_tiles/feather.png',
  '$_tiles/wrong.png',
  for (var n = 1; n <= 8; n++) '$_tiles/$n.png',
];

/// The side of a cell that makes the whole garden fit in [area].
double cellSize(Size area, Difficulty difficulty) {
  final room = 2 * (_framePadding + _margin);
  final size = min(
    (area.width - room) / difficulty.width,
    (area.height - room) / difficulty.height,
  );
  return size.clamp(6.0, _maxCell).floorToDouble();
}

class Board extends StatelessWidget {
  const Board({super.key, required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => ListenableBuilder(
      listenable: game,
      builder: (context, _) {
        final difficulty = game.difficulty;
        final size = cellSize(box.biggest, difficulty);
        return Center(
          child: Container(
            padding: const EdgeInsets.all(_framePadding),
            decoration: BoxDecoration(
              color: PsitoColors.frame,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              key: ValueKey(game.gameId),
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var y = 0; y < difficulty.height; y++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var x = 0; x < difficulty.width; x++)
                        _Cell(
                          key: ValueKey('cell-${y * difficulty.width + x}'),
                          game: game,
                          cell: y * difficulty.width + x,
                          size: size,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _Cell extends StatelessWidget {
  const _Cell({
    super.key,
    required this.game,
    required this.cell,
    required this.size,
  });

  final GameController game;
  final int cell;
  final double size;

  /// How long the opening takes to arrive here from the latest click.
  Duration get _delay {
    final origin = game.origin;
    if (origin == null) return Duration.zero;
    final width = game.difficulty.width;
    final steps = max(
      (cell % width - origin % width).abs(),
      (cell ~/ width - origin ~/ width).abs(),
    );
    return Duration(milliseconds: min(steps * 24, 420));
  }

  String _label(AppLocalizations l10n, GameState state) {
    final width = game.difficulty.width;
    final row = cell ~/ width + 1;
    final column = cell % width + 1;
    if (state.isLost && state.cats.contains(cell)) {
      return l10n.cellCat(row, column);
    }
    if (state.open.contains(cell)) {
      return l10n.cellOpen(state.catsAround(cell), row, column);
    }
    if (state.flags.contains(cell)) return l10n.cellFeather(row, column);
    return l10n.cellLeaf(row, column);
  }

  Widget _face(GameState state) {
    final isCat = state.cats.contains(cell);
    final flagged = state.flags.contains(cell);
    if (state.open.contains(cell)) {
      final count = state.catsAround(cell);
      return _Opening(
        delay: _delay,
        child: _Layers(['open', if (count > 0) '$count']),
      );
    }
    if (state.caughtAt == cell) {
      return _Opening(
        delay: Duration.zero,
        child: const _Layers(['caught', 'cat']),
      );
    }
    if (state.isLost && isCat && !flagged) {
      return _Opening(
        delay: _delay,
        child: const _Layers(['open', 'cat']),
      );
    }
    if (state.isLost && flagged && !isCat) {
      return const _Layers(['leaf', 'feather', 'wrong']);
    }
    if (flagged) {
      return const Stack(
        fit: StackFit.expand,
        children: [_Tile('leaf'), _Pop(child: _Tile('feather'))],
      );
    }
    return _Leaf(playing: !state.isOver);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = game.state;
    return Semantics(
      button: true,
      label: _label(l10n, state),
      onTap: () => game.tap(cell),
      onLongPress: () => game.flag(cell),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: () => game.tap(cell),
        onSecondaryTap: () => game.flag(cell),
        onLongPress: () => game.flag(cell),
        child: SizedBox.square(dimension: size, child: _face(state)),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.name);

  final String name;

  @override
  Widget build(BuildContext context) => Image.asset(
    '$_tiles/$name.png',
    fit: BoxFit.fill,
    filterQuality: FilterQuality.medium,
    gaplessPlayback: true,
  );
}

class _Layers extends StatelessWidget {
  const _Layers(this.names);

  final List<String> names;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [for (final name in names) _Tile(name)],
  );
}

/// A closed leaf, which lights up under the pointer while the game goes on.
class _Leaf extends StatefulWidget {
  const _Leaf({required this.playing});

  final bool playing;

  @override
  State<_Leaf> createState() => _LeafState();
}

class _LeafState extends State<_Leaf> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: AnimatedScale(
      scale: _hover && widget.playing ? 1.06 : 1,
      duration: const Duration(milliseconds: 90),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          _hover && widget.playing
              ? const Color(0x22FFFFFF)
              : const Color(0x00FFFFFF),
          BlendMode.srcATop,
        ),
        child: const _Tile('leaf'),
      ),
    ),
  );
}

/// The leaf shrinks away over what it hid, after a [delay].
class _Opening extends StatelessWidget {
  const _Opening({required this.delay, required this.child});

  static const _duration = 170;

  final Duration delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wait = delay.inMilliseconds;
    final total = wait + _duration;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(wait / total, 1, curve: Curves.easeOut),
      builder: (context, shown, content) => Stack(
        fit: StackFit.expand,
        children: [
          content!,
          if (shown < 1)
            Transform.scale(scale: 1 - shown, child: const _Tile('leaf')),
        ],
      ),
      child: child,
    );
  }
}

/// A feather that lands on the leaf.
class _Pop extends StatelessWidget {
  const _Pop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: .3, end: 1),
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutBack,
    builder: (context, scale, content) =>
        Transform.scale(scale: scale, child: content),
    child: child,
  );
}
