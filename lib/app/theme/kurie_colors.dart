import 'package:flutter/material.dart';

/// Kurie design system colors extracted from Stitch DESIGN.md.
/// "Utility-chic" palette — Technical White + Neon Blue + Amber accents.
class KurieColors {
  KurieColors._();

  // ── Surface System ──
  static const Color surface = Color(0xFFF2FBFC);
  static const Color surfaceDim = Color(0xFFD3DCDD);
  static const Color surfaceBright = Color(0xFFF2FBFC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEDF5F6);
  static const Color surfaceContainer = Color(0xFFE7EFF0);
  static const Color surfaceContainerHigh = Color(0xFFE1EAEB);
  static const Color surfaceContainerHighest = Color(0xFFDCE4E5);
  static const Color surfaceVariant = Color(0xFFDCE4E5);

  // ── Content on Surface ──
  static const Color onSurface = Color(0xFF151D1E);
  static const Color onSurfaceVariant = Color(0xFF3B494C);

  // ── Inverse ──
  static const Color inverseSurface = Color(0xFF2A3233);
  static const Color inverseOnSurface = Color(0xFFEAF2F3);
  static const Color inversePrimary = Color(0xFF00DAF3);

  // ── Outline ──
  static const Color outline = Color(0xFF6B7A7D);
  static const Color outlineVariant = Color(0xFFBAC9CC);

  // ── Primary (Neon Blue) ──
  static const Color primary = Color(0xFF006875);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF00E5FF);
  static const Color onPrimaryContainer = Color(0xFF00626E);
  static const Color surfaceTint = Color(0xFF006875);
  static const Color primaryFixed = Color(0xFF9CF0FF);
  static const Color primaryFixedDim = Color(0xFF00DAF3);
  static const Color onPrimaryFixed = Color(0xFF001F24);

  // ── Secondary ──
  static const Color secondary = Color(0xFF545F73);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD5E0F8);
  static const Color onSecondaryContainer = Color(0xFF586377);
  static const Color secondaryFixed = Color(0xFFD8E3FA);
  static const Color onSecondaryFixed = Color(0xFF111C2D);

  // ── Tertiary (Amber) ──
  static const Color tertiary = Color(0xFF7D5700);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFC865);
  static const Color onTertiaryContainer = Color(0xFF765300);
  static const Color tertiaryFixed = Color(0xFFFFDEA9);
  static const Color onTertiaryFixed = Color(0xFF271900);

  // ── Error ──
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Background (alias for surface in M3) ──
  static const Color background = Color(0xFFF2FBFC);
  static const Color onBackground = Color(0xFF151D1E);

  // ── Semantic accents ──
  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color amber = Color(0xFFFFC865);
  static const Color alertAmber = Color(0xFF7D5700);
}
