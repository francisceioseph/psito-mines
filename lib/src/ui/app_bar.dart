import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import '../game/game_state.dart';
import '../game/scores.dart';
import '../version.dart';
import 'colors.dart';
import 'victory_panel.dart';

enum _MenuItem { bestGames, howToPlay, about }

/// The bar above the table: the brand, the state of the game and the actions.
class GameAppBar extends StatelessWidget {
  const GameAppBar({super.key, required this.game});

  static const _compact = 860.0;
  static const _narrow = 600.0;

  final GameController game;

  void _showBestGames(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _BestGames(initial: game.difficulty),
    );
  }

  void _chooseDifficulty(Difficulty difficulty) {
    game.newGame(difficulty);
    const ScoreStore().saveDifficulty(difficulty);
  }

  void _howToPlay(BuildContext context) {
    showDialog<void>(context: context, builder: (_) => const _HowToPlay());
  }

  void _about(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: appVersion,
      applicationIcon: Image.asset('assets/mascot/peek.png', width: 48),
      applicationLegalese: l10n.aboutLegal,
      children: [
        const SizedBox(height: 16),
        Text(l10n.aboutBody),
        const SizedBox(height: 8),
        const SelectableText('https://francisceioseph.github.io/psito-mines/'),
      ],
    );
  }

  void _onMenu(BuildContext context, _MenuItem item) => switch (item) {
    _MenuItem.bestGames => _showBestGames(context),
    _MenuItem.howToPlay => _howToPlay(context),
    _MenuItem.about => _about(context),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [PsitoColors.barTop, PsitoColors.barBottom],
        ),
        border: Border(bottom: BorderSide(color: Color(0x33000000))),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final compact = box.maxWidth < _compact;
          final narrow = box.maxWidth < _narrow;
          final brand = _Brand(showName: !compact, title: l10n.appTitle);
          final stats = _GameStats(game: game);
          final actions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!narrow)
                _BarButton(
                  tooltip: l10n.bestGames,
                  icon: Icons.emoji_events_outlined,
                  onPressed: () => _showBestGames(context),
                ),
              _DifficultyButton(
                current: game.difficulty,
                iconOnly: narrow,
                onSelected: _chooseDifficulty,
              ),
              const SizedBox(width: 6),
              _NewGameButton(
                label: l10n.newGame,
                iconOnly: compact,
                onPressed: game.newGame,
              ),
              PopupMenuButton<_MenuItem>(
                tooltip: l10n.moreOptions,
                iconColor: PsitoColors.onFelt,
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(Icons.more_vert_rounded, size: 21),
                onSelected: (item) => _onMenu(context, item),
                itemBuilder: (context) => [
                  if (narrow)
                    PopupMenuItem(
                      value: _MenuItem.bestGames,
                      child: Text(l10n.bestGames),
                    ),
                  PopupMenuItem(
                    value: _MenuItem.howToPlay,
                    child: Text(l10n.howToPlay),
                  ),
                  PopupMenuItem(
                    value: _MenuItem.about,
                    child: Text(l10n.about),
                  ),
                ],
              ),
            ],
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            // The stats are centred only when there is room on both sides.
            child: Row(
              children: compact
                  ? [brand, const SizedBox(width: 12), stats, const Spacer(), actions]
                  : [
                      Expanded(child: brand),
                      stats,
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: actions,
                        ),
                      ),
                    ],
            ),
          );
        },
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.showName, required this.title});

  final bool showName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Image.asset(
            'assets/mascot/peek.png',
            height: 34,
            filterQuality: FilterQuality.medium,
          ),
        ),
        if (showName) ...[
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'CardSerif',
                fontSize: 19,
                color: PsitoColors.onFelt,
                letterSpacing: .2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _GameStats extends StatelessWidget {
  const _GameStats({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x26000000),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Stat(label: l10n.statCats, value: '${game.state.catsLeft}'),
            const _StatDivider(),
            _GameClock(game: game, label: l10n.statTime),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) => const VerticalDivider(
    width: 1,
    thickness: 1,
    indent: 4,
    endIndent: 4,
    color: Color(0x1FFFFFFF),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $value',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 9.5,
                height: 1.25,
                letterSpacing: .9,
                fontWeight: FontWeight.w600,
                color: PsitoColors.onFeltMuted,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: PsitoColors.onFelt,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The time played, redrawn once per second.
class _GameClock extends StatefulWidget {
  const _GameClock({required this.game, required this.label});

  final GameController game;
  final String label;

  @override
  State<_GameClock> createState() => _GameClockState();
}

class _GameClockState extends State<_GameClock> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _Stat(label: widget.label, value: formatTime(widget.game.seconds));
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: 21),
    style: IconButton.styleFrom(
      visualDensity: VisualDensity.compact,
      foregroundColor: PsitoColors.onFelt,
      disabledForegroundColor: PsitoColors.feltLight.withValues(alpha: .55),
      hoverColor: const Color(0x1AFFFFFF),
    ),
  );
}

class _NewGameButton extends StatelessWidget {
  const _NewGameButton({
    required this.label,
    required this.iconOnly,
    required this.onPressed,
  });

  final String label;
  final bool iconOnly;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: PsitoColors.cream,
      foregroundColor: PsitoColors.barBottom,
      padding: EdgeInsets.symmetric(horizontal: iconOnly ? 10 : 14),
      minimumSize: const Size(40, 38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    );
    const icon = Icon(Icons.casino_outlined, size: 19);
    if (iconOnly) {
      return Tooltip(
        message: '$label  (Ctrl+N)',
        child: FilledButton(onPressed: onPressed, style: style, child: icon),
      );
    }
    return Tooltip(
      message: 'Ctrl+N',
      child: FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: icon,
        label: Text(label),
      ),
    );
  }
}

String difficultyName(AppLocalizations l10n, Difficulty difficulty) =>
    switch (difficulty) {
      Difficulty.easy => l10n.easy,
      Difficulty.medium => l10n.medium,
      Difficulty.hard => l10n.hard,
    };

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.current,
    required this.iconOnly,
    required this.onSelected,
  });

  final Difficulty current;
  final bool iconOnly;
  final void Function(Difficulty) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<Difficulty>(
      tooltip: l10n.difficulty,
      initialValue: current,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final difficulty in Difficulty.values)
          PopupMenuItem(
            value: difficulty,
            child: Text(
              l10n.difficultyDetail(
                difficultyName(l10n, difficulty),
                difficulty.width,
                difficulty.height,
                difficulty.cats,
              ),
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconOnly)
              const Icon(Icons.tune_rounded, size: 21, color: PsitoColors.onFelt)
            else
              Text(
                difficultyName(l10n, current),
                style: const TextStyle(
                  color: PsitoColors.onFelt,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 20,
              color: PsitoColors.onFeltMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _BestGames extends StatefulWidget {
  const _BestGames({required this.initial});

  final Difficulty initial;

  @override
  State<_BestGames> createState() => _BestGamesState();
}

class _BestGamesState extends State<_BestGames> {
  late Difficulty _difficulty = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.bestGames),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<Difficulty>(
              showSelectedIcon: false,
              selected: {_difficulty},
              onSelectionChanged: (chosen) =>
                  setState(() => _difficulty = chosen.single),
              segments: [
                for (final difficulty in Difficulty.values)
                  ButtonSegment(
                    value: difficulty,
                    label: Text(difficultyName(l10n, difficulty)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            FutureBuilder<List<Score>>(
              key: ValueKey(_difficulty),
              future: const ScoreStore().load(_difficulty),
              builder: (context, snapshot) =>
                  ScoreTable(scores: snapshot.data ?? const []),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

class _HowToPlay extends StatelessWidget {
  const _HowToPlay();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.howToPlay),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(child: Text(l10n.howToPlayBody)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
