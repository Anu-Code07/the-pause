import 'package:flutter/material.dart';

class PauseColors {
  static const ink = Color(0xFF111111);
  static const inkSoft = Color(0xFF3A3A3A);
  /// Cool white, not warm cream.
  static const cream = Color(0xFFFFFFFF);
  static const paper = Color(0xFFFFFFFF);
  static const mist = Color(0xFFF3F3F3);
  static const stone = Color(0xFF8E8E93);
  static const gold = Color(0xFFC6A35A);
  static const goldDeep = Color(0xFF9C7A45);
  static const skySteel = Color(0xFF6E849E);
  static const hairline = Color(0xFFE5E5EA);
}

class PauseShadows {
  static final soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];
}

class PauseTheme {
  static ThemeData light() {
    const textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Playfair Display',
        fontSize: 48,
        height: 1.05,
        fontWeight: FontWeight.w500,
        color: PauseColors.ink,
        letterSpacing: -0.8,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Playfair Display',
        fontSize: 36,
        height: 1.12,
        fontWeight: FontWeight.w500,
        color: PauseColors.ink,
        letterSpacing: -0.4,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Playfair Display',
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w500,
        color: PauseColors.ink,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: PauseColors.ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: PauseColors.inkSoft,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: PauseColors.stone,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: PauseColors.ink,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: PauseColors.cream,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        primary: PauseColors.ink,
        onPrimary: PauseColors.paper,
        surface: PauseColors.cream,
        onSurface: PauseColors.ink,
        secondary: PauseColors.gold,
      ),
      textTheme: textTheme,
      dividerColor: PauseColors.hairline,
      appBarTheme: const AppBarTheme(
        backgroundColor: PauseColors.cream,
        foregroundColor: PauseColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 26,
          fontWeight: FontWeight.w500,
          color: PauseColors.ink,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PauseColors.ink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: PauseColors.mist,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }
}
