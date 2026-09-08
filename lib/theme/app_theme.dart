import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette premium. Les teintes de base restent fidèles à l'identité
/// TekaTech Congo (styles.css : --ink, --brand, --brand-2, --accent,
/// --flag-*) ; le thème sombre est une extension cohérente pensée pour
/// un rendu "app tech" plus immersif.
class AppColors {
  AppColors._();

  // Marque (communs aux deux thèmes)
  static const brand = Color(0xFF123A73);
  static const brand2 = Color(0xFF1E6FE0);
  static const accent = Color(0xFF3FA9F5);
  static const accentCyan = Color(0xFF35E0C7);

  static const flagGreen = Color(0xFF009543);
  static const flagYellow = Color(0xFFFFCB05);
  static const flagRed = Color(0xFFCE1126);

  // Thème clair
  static const ink = Color(0xFF0B1B33);
  static const inkSoft = Color(0xFF4A5A78);
  static const bg = Color(0xFFF5F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFDDE4EF);

  // Thème sombre — bleu nuit profond, pas un noir plat
  static const inkDark = Color(0xFFEAF1FF);
  static const inkSoftDark = Color(0xFFA9B9D8);
  static const bgDark = Color(0xFF060B18);
  static const surfaceDark = Color(0xFF0E1830);
  static const lineDark = Color(0xFF1E2C4D);

  static const success = flagGreen;
  static const danger = Color(0xFFE5484D);
}

class AppGradients {
  AppGradients._();

  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand, AppColors.brand2, AppColors.accentCyan],
    stops: [0.0, 0.6, 1.0],
  );

  static const heroDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF050914), AppColors.brand, AppColors.brand2],
  );

  static const flag = LinearGradient(
    colors: [AppColors.flagGreen, AppColors.flagYellow, AppColors.flagRed],
  );
}

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(TextTheme base, Color ink, Color inkSoft) {
    final heading = GoogleFonts.spaceGroteskTextTheme(base);
    final body = GoogleFonts.manropeTextTheme(base);
    return body.copyWith(
      displayLarge: heading.displayLarge?.copyWith(color: ink, fontWeight: FontWeight.w700),
      displayMedium: heading.displayMedium?.copyWith(color: ink, fontWeight: FontWeight.w700),
      headlineLarge: heading.headlineLarge?.copyWith(color: ink, fontWeight: FontWeight.w700),
      headlineMedium: heading.headlineMedium?.copyWith(color: ink, fontWeight: FontWeight.w700),
      headlineSmall: heading.headlineSmall?.copyWith(color: ink, fontWeight: FontWeight.w700),
      titleLarge: heading.titleLarge?.copyWith(color: ink, fontWeight: FontWeight.w600),
      titleMedium: heading.titleMedium?.copyWith(color: ink, fontWeight: FontWeight.w600),
      bodyLarge: body.bodyLarge?.copyWith(color: inkSoft, height: 1.55),
      bodyMedium: body.bodyMedium?.copyWith(color: inkSoft, height: 1.55),
      labelLarge: body.labelLarge?.copyWith(color: ink, fontWeight: FontWeight.w700),
    );
  }

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brand2,
        primary: AppColors.brand2,
        secondary: AppColors.accentCyan,
        surface: AppColors.surface,
        error: AppColors.danger,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );
    return _build(base, ink: AppColors.ink, inkSoft: AppColors.inkSoft, surface: AppColors.surface, line: AppColors.line, bg: AppColors.bg);
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brand2,
        primary: AppColors.accentCyan,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        error: AppColors.danger,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
    );
    return _build(base, ink: AppColors.inkDark, inkSoft: AppColors.inkSoftDark, surface: AppColors.surfaceDark, line: AppColors.lineDark, bg: AppColors.bgDark);
  }

  static ThemeData _build(
    ThemeData base, {
    required Color ink,
    required Color inkSoft,
    required Color surface,
    required Color line,
    required Color bg,
  }) {
    return base.copyWith(
      textTheme: _textTheme(base.textTheme, ink, inkSoft),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand2,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(48, 52),
          side: BorderSide(color: line),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brand2, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
