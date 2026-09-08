import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contrôleur simple pour le mode clair/sombre, persisté sur l'appareil.
/// Volontairement minimaliste (ValueNotifier) plutôt qu'un package de
/// gestion d'état externe supplémentaire.
class ThemeController extends ValueNotifier<ThemeMode> {
  static const _prefsKey = 'tekatech_theme_mode';

  ThemeController() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefsKey);
      if (saved == 'dark') value = ThemeMode.dark;
      if (saved == 'light') value = ThemeMode.light;
    } catch (_) {
      // Pas bloquant si les préférences ne sont pas disponibles.
    }
  }

  Future<void> toggle() async {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, value == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {
      // Silencieux : le thème reste actif pour la session en cours.
    }
  }

  bool get isDark => value == ThemeMode.dark;
}
