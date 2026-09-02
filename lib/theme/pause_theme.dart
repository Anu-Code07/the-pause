import 'package:flutter/material.dart';

class PauseColors {
  static const ink = Color(0xFF111111);
  static const inkSoft = Color(0xFF3A3A3A);
  static const cream = Color(0xFFF6F3EE);
  static const paper = Color(0xFFFFFCF8);
  static const mist = Color(0xFFE8E4DC);
  static const stone = Color(0xFF8A847A);
  static const gold = Color(0xFFC4A574);
  static const goldDeep = Color(0xFF9C7A45);
  static const skySteel = Color(0xFF6E849E);
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
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: PauseColors.ink,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: PauseColors.cream,
      colorScheme: const ColorScheme.light(
        primary: PauseColors.ink,
        onPrimary: PauseColors.paper,
        surface: PauseColors.cream,
        onSurface: PauseColors.ink,
        secondary: PauseColors.gold,
      ),
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: PauseColors.cream,
        foregroundColor: PauseColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: PauseColors.ink,
        ),
      ),
    );
  }
}
