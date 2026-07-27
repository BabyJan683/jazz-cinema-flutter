import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Map<String, AppThemeData> themes = {
    'netflix_red': AppThemeData(
      name: 'Default — Netflix Red',
      emoji: '🎬',
      primary: Color(0xFFE50914),
      secondary: Color(0xFFB81D24),
      accent: Color(0xFFFF3B30),
      background: Color(0xFF0A0A0F),
      surface: Color(0xFF141418),
      surfaceVariant: Color(0xFF1E1E24),
      card: Color(0xFF1A1A20),
      onPrimary: Color(0xFFFFFFFF),
    ),
    'ocean_blue': AppThemeData(
      name: 'Blue + Orange — Ocean',
      emoji: '🌊',
      primary: Color(0xFF0073CF),
      secondary: Color(0xFF0057A6),
      accent: Color(0xFFFF6B00),
      background: Color(0xFF080C14),
      surface: Color(0xFF0D1420),
      surfaceVariant: Color(0xFF131D2E),
      card: Color(0xFF101828),
      onPrimary: Color(0xFFFFFFFF),
    ),
    'royal_purple': AppThemeData(
      name: '👑 Purple + Gold — Royal Cinema',
      emoji: '👑',
      primary: Color(0xFF7B2FBE),
      secondary: Color(0xFF5A1E8C),
      accent: Color(0xFFFFD700),
      background: Color(0xFF0C0812),
      surface: Color(0xFF14101E),
      surfaceVariant: Color(0xFF1C152A),
      card: Color(0xFF181224),
      onPrimary: Color(0xFFFFFFFF),
    ),
    'night_teal': AppThemeData(
      name: '🌙 Teal + Dark — Night Mode',
      emoji: '🌙',
      primary: Color(0xFF00B4A6),
      secondary: Color(0xFF008C80),
      accent: Color(0xFF00E5D4),
      background: Color(0xFF060C0C),
      surface: Color(0xFF0C1414),
      surfaceVariant: Color(0xFF111E1E),
      card: Color(0xFF0F1A1A),
      onPrimary: Color(0xFF000000),
    ),
    'cinema_amber': AppThemeData(
      name: '🔥 Amber + Warm — Cinema Warm',
      emoji: '🔥',
      primary: Color(0xFFFF8C00),
      secondary: Color(0xFFCC7000),
      accent: Color(0xFFFFB347),
      background: Color(0xFF0F0A04),
      surface: Color(0xFF1A1208),
      surfaceVariant: Color(0xFF241A0C),
      card: Color(0xFF1E1508),
      onPrimary: Color(0xFF000000),
    ),
  };

  static ThemeData buildTheme(String themeKey) {
    final t = themes[themeKey] ?? themes['netflix_red']!;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: t.primary,
        secondary: t.accent,
        surface: t.surface,
        background: t.background,
        onPrimary: t.onPrimary,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      scaffoldBackgroundColor: t.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: t.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: t.surface,
        selectedItemColor: t.primary,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: t.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: t.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: Colors.white38),
        labelStyle: const TextStyle(color: Colors.white60),
      ),
    );
  }
}

class AppThemeData {
  final String name;
  final String emoji;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color card;
  final Color onPrimary;

  const AppThemeData({
    required this.name,
    required this.emoji,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.onPrimary,
  });
}
