import 'package:flutter/material.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n.dart';
import '../../game/game_controller.dart';
import '../../game/game_state.dart';
import '../../game/scores.dart';
import '../../version.dart';
import 'victory_panel.dart';

String difficultyName(AppLocalizations l10n, Difficulty difficulty) =>
    switch (difficulty) {
      Difficulty.easy => l10n.easy,
      Difficulty.medium => l10n.medium,
      Difficulty.hard => l10n.hard,
    };

/// What Psito Mines says about itself.
GameInfo minesInfo(AppLocalizations l10n) => GameInfo(
  title: l10n.appTitle,
  version: appVersion,
  howToPlay: l10n.howToPlayBody,
  about: l10n.aboutBody,
  legal: l10n.aboutLegal,
  site: 'https://francisceioseph.github.io/psito-mines/',
);

/// The bar of the garden: the cats left, the clock and the difficulty.
class MinesBar extends StatelessWidget {
  const MinesBar({super.key, required this.game});

  final GameController game;

  void _chooseDifficulty(Difficulty difficulty) {
    game.newGame(difficulty);
    const ScoreStore().saveDifficulty(difficulty);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GameBar(
      info: minesInfo(l10n),
      onNewGame: game.newGame,
      onBestGames: () => showBestGames(
        context,
        _BestGames(initial: game.difficulty),
      ),
      stats: (space) => StatsPill(
        children: [
          StatTile(label: l10n.statCats, value: '${game.state.catsLeft}'),
          ClockStat(seconds: () => game.seconds),
        ],
      ),
      actions: (space) => [
        ChoiceButton<Difficulty>(
          tooltip: context.gamesUi.difficulty,
          current: game.difficulty,
          choices: Difficulty.values,
          iconOnly: space.narrow,
          label: (difficulty) => difficultyName(l10n, difficulty),
          menuLabel: (difficulty) => l10n.difficultyDetail(
            difficultyName(l10n, difficulty),
            difficulty.width,
            difficulty.height,
            difficulty.cats,
          ),
          onSelected: _chooseDifficulty,
        ),
      ],
    );
  }
}

/// The best games of each difficulty, starting from the one being played.
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
    final l10n = context.l10n;
    return Column(
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
              MinesScoreTable(scores: snapshot.data ?? const []),
        ),
      ],
    );
  }
}
