import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF121212);
  static const Color glassSurface = Color(0x1AFFFFFF); // White with 10% opacity
  static const Color accentGold = Color(0xFFD4AF37); // Gold/Champagne
  static const Color accentPurple = Color(0xFF8A2BE2); // Electric Purple
  static const Color accentBlue = Color(0xFF00B4D8); // Electric Blue
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color neumorphicShadowLight = Color(0x33FFFFFF);
  static const Color neumorphicShadowDark = Color(0x80000000);

  static ThemeData getDarkTheme(String theme) {
    Color accentColor = accentGold;
    if (theme == 'lash_studio') {
      accentColor = accentGold;
    } else if (theme == 'smoke_shop') {
      accentColor = accentPurple;
    }

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: accentColor,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentBlue, 
        surface: glassSurface,
        background: background,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        error: Colors.redAccent,
        onError: textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}
