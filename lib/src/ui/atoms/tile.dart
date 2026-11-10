import 'package:flutter/material.dart';

const _tiles = 'assets/tiles';

/// Every drawing of the garden, to load them before the first game.
Iterable<String> allTileArt() => [
  '$_tiles/leaf.png',
  '$_tiles/open.png',
  '$_tiles/caught.png',
  '$_tiles/cat.png',
  '$_tiles/feather.png',
  '$_tiles/wrong.png',
  for (var n = 1; n <= 8; n++) '$_tiles/$n.png',
];

/// One drawing of the garden, stretched over its cell.
class Tile extends StatelessWidget {
  const Tile(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) => Image.asset(
    '$_tiles/$name.png',
    fit: BoxFit.fill,
    filterQuality: FilterQuality.medium,
    gaplessPlayback: true,
  );
}

/// Drawings one over the other, such as a number over the open ground.
class TileLayers extends StatelessWidget {
  const TileLayers(this.names, {super.key});

  final List<String> names;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [for (final name in names) Tile(name)],
  );
}
