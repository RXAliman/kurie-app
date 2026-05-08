import 'package:flutter/material.dart';
import 'kurie_colors.dart';

/// Kurie app theme — Utility-Chic light theme with Inter typography.
class KurieTheme {
  KurieTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: KurieColors.primary,
      onPrimary: KurieColors.onPrimary,
      primaryContainer: KurieColors.primaryContainer,
      onPrimaryContainer: KurieColors.onPrimaryContainer,
      secondary: KurieColors.secondary,
      onSecondary: KurieColors.onSecondary,
      secondaryContainer: KurieColors.secondaryContainer,
      onSecondaryContainer: KurieColors.onSecondaryContainer,
      tertiary: KurieColors.tertiary,
      onTertiary: KurieColors.onTertiary,
      tertiaryContainer: KurieColors.tertiaryContainer,
      onTertiaryContainer: KurieColors.onTertiaryContainer,
      error: KurieColors.error,
      onError: KurieColors.onError,
      errorContainer: KurieColors.errorContainer,
      onErrorContainer: KurieColors.onErrorContainer,
      surface: KurieColors.surface,
      onSurface: KurieColors.onSurface,
      surfaceContainerHighest: KurieColors.surfaceContainerHighest,
      outline: KurieColors.outline,
      outlineVariant: KurieColors.outlineVariant,
      inverseSurface: KurieColors.inverseSurface,
      onInverseSurface: KurieColors.inverseOnSurface,
      inversePrimary: KurieColors.inversePrimary,
      surfaceTint: KurieColors.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: KurieColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: KurieColors.surface,
        foregroundColor: KurieColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: KurieColors.onSurface,
          letterSpacing: -0.01,
        ),
      ),
      cardTheme: CardThemeData(
        color: KurieColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: KurieColors.outlineVariant, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KurieColors.primary,
          foregroundColor: KurieColors.onPrimary,
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
          foregroundColor: KurieColors.onSurface,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(color: KurieColors.outlineVariant),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KurieColors.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: KurieColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: KurieColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: KurieColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: KurieColors.error),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: KurieColors.onSurfaceVariant,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: KurieColors.outline,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: KurieColors.surfaceContainerLowest,
        selectedItemColor: KurieColors.primary,
        unselectedItemColor: KurieColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: KurieColors.outlineVariant,
        thickness: 1,
        space: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 56 / 48,
          letterSpacing: -0.96,
          color: KurieColors.onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 40,
          fontWeight: FontWeight.w600,
          height: 48 / 40,
          letterSpacing: -0.8,
          color: KurieColors.onSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
          letterSpacing: -0.32,
          color: KurieColors.onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 32 / 24,
          color: KurieColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 28 / 18,
          color: KurieColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: KurieColors.onSurface,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 20 / 14,
          color: KurieColors.onSurface,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: KurieColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
