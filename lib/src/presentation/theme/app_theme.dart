// ABOUTME: Central app theme: color scheme, typography, and component themes for a professional look.
// ABOUTME: Material 3; Serbian market; government/open-data feel (clean, trustworthy).

import 'package:flutter/material.dart';

/// App-wide theme. Light theme tuned for readability and a professional, trustworthy feel.
class AppTheme {
  AppTheme._();

  static const Color _primaryBlue = Color(0xFF0D47A1);
  static const Color _primaryContainerLight = Color(0xFFD1E4FF);
  static const Color _outlineVariant = Color(0xFFC4C9D0);

  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: _primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: _primaryContainerLight,
      onPrimaryContainer: const Color(0xFF001D36),
      secondary: const Color(0xFF535F70),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFD7E3F7),
      onSecondaryContainer: const Color(0xFF101C2B),
      surface: Colors.white,
      onSurface: const Color(0xFF1A1C1E),
      surfaceContainerHighest: const Color(0xFFE8EDF4),
      onSurfaceVariant: const Color(0xFF43474E),
      outline: const Color(0xFF73777F),
      outlineVariant: _outlineVariant,
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
    );

    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      headlineMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: const TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: const TextStyle(fontSize: 14, height: 1.43),
      bodySmall: const TextStyle(fontSize: 12, height: 1.33),
      labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    );
  }
}
