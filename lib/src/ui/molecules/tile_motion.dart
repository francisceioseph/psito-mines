import 'package:flutter/material.dart';

import '../atoms/tile.dart';

/// A closed leaf, which lights up under the pointer while the game goes on.
class Leaf extends StatefulWidget {
  const Leaf({super.key, required this.playing});

  final bool playing;

  @override
  State<Leaf> createState() => _LeafState();
}

class _LeafState extends State<Leaf> {
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
        child: const Tile('leaf'),
      ),
    ),
  );
}

/// The leaf shrinks away over what it hid, after a [delay].
class Opening extends StatelessWidget {
  const Opening({super.key, required this.delay, required this.child});

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
            Transform.scale(scale: 1 - shown, child: const Tile('leaf')),
        ],
      ),
      child: child,
    );
  }
}

/// A feather that lands on the leaf.
class Pop extends StatelessWidget {
  const Pop({super.key, required this.child});

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
