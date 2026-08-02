import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      textTheme: _buildLightTextTheme(),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      textTheme: _buildDarkTextTheme(),
    );
  }

  static TextTheme _buildLightTextTheme() {
    const onSurfaceVariant = Color(0xFF79747E);
    return TextTheme(
      titleLarge: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.black87,
      ),

      titleMedium: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: Colors.black87,
      ),

      labelSmall: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: onSurfaceVariant,
      ),

      bodyMedium: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: Colors.black87,
      ),

      bodySmall: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        color: onSurfaceVariant,
      ),
    );
  }

  static TextTheme _buildDarkTextTheme() {
    const onSurfaceVariant = Color(0xFFC4C7C5);
    return TextTheme(
      titleLarge: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.white,
      ),

      titleMedium: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: Colors.white,
      ),

      labelSmall: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: onSurfaceVariant,
      ),

      bodyMedium: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: Colors.white70,
      ),

      bodySmall: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        color: onSurfaceVariant,
      ),
    );
  }
}
