import 'dart:math';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n.dart';
import '../../game/game_controller.dart';
import '../../game/game_state.dart';
import '../atoms/tile.dart';
import 'tile_motion.dart';

/// One leaf of the garden, with what is under it once lifted.
class GardenCell extends StatelessWidget {
  const GardenCell({
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
      return Opening(
        delay: _delay,
        child: TileLayers(['open', if (count > 0) '$count']),
      );
    }
    if (state.caughtAt == cell) {
      return const Opening(
        delay: Duration.zero,
        child: TileLayers(['caught', 'cat']),
      );
    }
    if (state.isLost && isCat && !flagged) {
      return Opening(
        delay: _delay,
        child: const TileLayers(['open', 'cat']),
      );
    }
    if (state.isLost && flagged && !isCat) {
      return const TileLayers(['leaf', 'feather', 'wrong']);
    }
    if (flagged) {
      return const Stack(
        fit: StackFit.expand,
        children: [Tile('leaf'), Pop(child: Tile('feather'))],
      );
    }
    return Leaf(playing: !state.isOver);
  }

  @override
  Widget build(BuildContext context) {
    final state = game.state;
    return Semantics(
      button: true,
      label: _label(context.l10n, state),
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
