import 'dart:math';

import 'package:flutter/material.dart';

import '../../game/game_controller.dart';
import '../../game/game_state.dart';
import '../atoms/colors.dart';
import '../molecules/garden_cell.dart';

const _maxCell = 52.0;
const _framePadding = 8.0;
const _margin = 12.0;

/// The side of a cell that makes the whole garden fit in [area].
double cellSize(Size area, Difficulty difficulty) {
  final room = 2 * (_framePadding + _margin);
  final size = min(
    (area.width - room) / difficulty.width,
    (area.height - room) / difficulty.height,
  );
  return size.clamp(6.0, _maxCell).floorToDouble();
}

/// The garden in its frame, as big as the window lets it be.
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
                        GardenCell(
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
