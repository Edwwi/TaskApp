import 'package:flutter/material.dart';

class AppTheme {
  static const primaryBlue = Color(0xFF3F51B5);
  static const secondaryBlue = Color(0xFF2196F3);
  static const accentBlue = Color(0xFF03A9F4);
  static const backgroundLight = Color(0xFFF5F7FB);
  static const backgroundDark = Color(0xFF121212);
  static const cardShadow = Color(0x1A000000);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: Colors.white,
        background: backgroundLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: const Color(0xFF1E1E1E),
        background: backgroundDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF2C2C2C),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      ),
    );
  }

  static BoxDecoration get blueGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryBlue, accentBlue],
    ),
  );
}
