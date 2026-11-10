import 'package:flutter/material.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

abstract final class PsitoColors {
  static const felt = Color(0xFF4A3B52);
  static const feltGlow = Color(0xFF5E4C68);
  static const feltDark = Color(0xFF382C40);
  static const feltLight = Color(0xFFA796B2);
  static const cream = Color(0xFFF6EED6);
  static const black = Color(0xFF3B3842);
  static const frame = Color(0xFF2B2132);
  static const danger = Color(0xFFE2725B);
  static const onFelt = Color(0xFFF3EFE0);
  static const onFeltMuted = Color(0xFFC3B3CC);
  static const barTop = Color(0xFF35293D);
  static const barBottom = Color(0xFF2A2031);
}

/// The garden at dusk, for the shared widgets.
const minesPalette = GamePalette(
  felt: PsitoColors.felt,
  feltGlow: PsitoColors.feltGlow,
  feltDark: PsitoColors.feltDark,
  feltLight: PsitoColors.feltLight,
  barTop: PsitoColors.barTop,
  barBottom: PsitoColors.barBottom,
  onFelt: PsitoColors.onFelt,
  onFeltMuted: PsitoColors.onFeltMuted,
  cream: PsitoColors.cream,
  ink: PsitoColors.black,
);
