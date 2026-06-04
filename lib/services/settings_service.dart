import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _themeModeKey = 'themeMode';
  static const String _languageKey = 'language';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('es');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final themeIndex = prefs.getInt(_themeModeKey);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    // Load language
    final langCode = prefs.getString(_languageKey);
    if (langCode != null) {
      _locale = Locale(langCode);
    }
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
