import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/splash_screen.dart';

final themeController = ThemeController();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TekaTechApp());
}

class TekaTechApp extends StatelessWidget {
  const TekaTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: MaterialApp(
            title: 'TekaTech Congo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
            // Respecte les réglages d'accessibilité système : la taille du
            // texte choisie par l'utilisateur (Réglages > Accessibilité)
            // n'est jamais bridée ici.
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
