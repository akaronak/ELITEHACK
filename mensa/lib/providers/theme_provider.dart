import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';

  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'en'; // 'en' or 'hi'

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Theme colors
  static const Color _primaryPurple = Color(0xFFD4C4E8);
  static const Color _darkPurple = Color(0xFF9B7FC8);
  static const Color _lightPurple = Color(0xFFF0E6FA);
  static const Color _backgroundColor = Color(0xFFFAF5FF);

  ThemeProvider() {
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
    _loadLanguage();
  }

  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeKey) ?? 'light';
    _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void _loadLanguage() {
    _language = _prefs.getString(_languageKey) ?? 'en';
  }

  Future<void> setTheme(ThemeMode theme) async {
    _themeMode = theme;
    await _prefs.setString(
      _themeKey,
      theme == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newTheme = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setTheme(newTheme);
  }

  Future<void> setLanguage(String lang) async {
    if (lang != 'en' && lang != 'hi') return;
    _language = lang;
    await _prefs.setString(_languageKey, lang);
    notifyListeners();
  }

  // Light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryPurple,
      scaffoldBackgroundColor: _backgroundColor,
      colorScheme: ColorScheme.light(
        primary: _primaryPurple,
        secondary: _darkPurple,
        surface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightPurple,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryPurple,
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      colorScheme: ColorScheme.dark(
        primary: _primaryPurple,
        secondary: _darkPurple,
        surface: const Color(0xFF16213E),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF16213E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF16213E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9B7FC8), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF16213E),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
