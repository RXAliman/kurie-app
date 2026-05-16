import 'package:flutter/material.dart';

/// Kurie design system colors extracted from Stitch DESIGN.md.
/// "Utility-chic" palette — Technical White + Neon Blue + Amber accents.
class KurieColors {
  KurieColors._();

  // ── Light Mode Palette ──
  static const Color surfaceLight = Color(0xFFF2FBFC);
  static const Color surfaceDimLight = Color(0xFFD3DCDD);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowLight = Color(0xFFEDF5F6);
  static const Color surfaceContainerLight = Color(0xFFE7EFF0);
  static const Color surfaceContainerHighLight = Color(0xFFE1EAEB);
  static const Color surfaceContainerHighestLight = Color(0xFFDCE4E5);
  static const Color onSurfaceLight = Color(0xFF151D1E);
  static const Color onSurfaceVariantLight = Color(0xFF3B494C);
  static const Color outlineLight = Color(0xFF6B7A7D);
  static const Color outlineVariantLight = Color(0xFFBAC9CC);
  static const Color primaryLight = Color(0xFF006875);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFF00E5FF);
  static const Color onPrimaryContainerLight = Color(0xFF00626E);

  // ── Dark Mode Palette ──
  static const Color surfaceDark = Color(0xFF0A1011);
  static const Color surfaceDimDark = Color(0xFF0A1011);
  static const Color surfaceContainerLowestDark = Color(0xFF050808);
  static const Color surfaceContainerLowDark = Color(0xFF0F1617);
  static const Color surfaceContainerDark = Color(0xFF151D1E);
  static const Color surfaceContainerHighDark = Color(0xFF1B2526);
  static const Color surfaceContainerHighestDark = Color(0xFF222D2F);
  static const Color onSurfaceDark = Color(0xFFE1EAEB);
  static const Color onSurfaceVariantDark = Color(0xFF8A9294);
  static const Color outlineDark = Color(0xFF8A9294);
  static const Color outlineVariantDark = Color(0xFF3F484A);
  static const Color primaryDark = Color(0xFF00DAF3);
  static const Color onPrimaryDark = Color(0xFF00363D);
  static const Color primaryContainerDark = Color(0xFF004E58);
  static const Color onPrimaryContainerDark = Color(0xFF9CF0FF);

  // ── Shared Colors ──
  static const Color tertiary = Color(0xFF7D5700);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFC865);
  static const Color onTertiaryContainer = Color(0xFF765300);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color amber = Color(0xFFFFC865);

  // Legacy aliases (for backward compatibility during transition)
  static const Color surface = surfaceLight;
  static const Color surfaceDim = surfaceDimLight;
  static const Color surfaceContainerLowest = surfaceContainerLowestLight;
  static const Color surfaceContainerLow = surfaceContainerLowLight;
  static const Color surfaceContainer = surfaceContainerLight;
  static const Color surfaceContainerHigh = surfaceContainerHighLight;
  static const Color surfaceContainerHighest = surfaceContainerHighestLight;
  static const Color onSurface = onSurfaceLight;
  static const Color onSurfaceVariant = onSurfaceVariantLight;
  static const Color outline = outlineLight;
  static const Color outlineVariant = outlineVariantLight;
  static const Color primary = primaryLight;
  static const Color onPrimary = onPrimaryLight;
  static const Color primaryContainer = primaryContainerLight;
  static const Color onPrimaryContainer = onPrimaryContainerLight;
  
  // Fixed/Accent colors used in some screens
  static const Color primaryFixed = Color(0xFF9CF0FF);
  static const Color onPrimaryFixed = Color(0xFF001F24);
  static const Color secondary = Color(0xFF545F73);
  static const Color secondaryFixed = Color(0xFFD8E3FA);
  static const Color onSecondaryFixed = Color(0xFF111C2D);
  static const Color tertiaryFixed = Color(0xFFFFDEA9);
}


