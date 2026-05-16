import 'package:flutter/material.dart';
import 'kurie_colors.dart';

/// Kurie app theme — Utility-Chic light theme with Inter typography.
class KurieTheme {
  KurieTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: KurieColors.primaryLight,
      onPrimary: KurieColors.onPrimaryLight,
      primaryContainer: KurieColors.primaryContainerLight,
      onPrimaryContainer: KurieColors.onPrimaryContainerLight,
      secondary: const Color(0xFF545F73),
      onSecondary: Colors.white,
      tertiary: KurieColors.tertiary,
      onTertiary: KurieColors.onTertiary,
      error: KurieColors.error,
      onError: KurieColors.onError,
      surface: KurieColors.surfaceLight,
      onSurface: KurieColors.onSurfaceLight,
      outline: KurieColors.outlineLight,
      outlineVariant: KurieColors.outlineVariantLight,
    );

    return _buildTheme(colorScheme, KurieColors.surfaceLight, KurieColors.surfaceContainerLowestLight);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: KurieColors.primaryDark,
      onPrimary: KurieColors.onPrimaryDark,
      primaryContainer: KurieColors.primaryContainerDark,
      onPrimaryContainer: KurieColors.onPrimaryContainerDark,
      secondary: const Color(0xFFBEC8DC),
      onSecondary: const Color(0xFF283141),
      tertiary: KurieColors.tertiary,
      onTertiary: KurieColors.onTertiary,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      surface: KurieColors.surfaceDark,
      onSurface: KurieColors.onSurfaceDark,
      outline: KurieColors.outlineDark,
      outlineVariant: KurieColors.outlineVariantDark,
    );

    return _buildTheme(colorScheme, KurieColors.surfaceDark, KurieColors.surfaceContainerLowestDark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Color scaffoldBg, Color surfaceLowest) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          letterSpacing: -0.01,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.outline,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceLowest,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 0,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 56 / 48,
          letterSpacing: -0.96,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 40,
          fontWeight: FontWeight.w600,
          height: 48 / 40,
          letterSpacing: -0.8,
          color: colorScheme.onSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
          letterSpacing: -0.32,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 32 / 24,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 28 / 18,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: colorScheme.onSurface,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 20 / 14,
          color: colorScheme.onSurface,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

}
