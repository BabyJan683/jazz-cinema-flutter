import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../config/themes.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme = AppConstants.themeNetflixRed;
  String get currentTheme => _currentTheme;

  AppThemeData get themeData =>
      AppThemes.themes[_currentTheme] ?? AppThemes.themes[AppConstants.themeNetflixRed]!;

  ThemeData get theme => AppThemes.buildTheme(_currentTheme);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString(AppConstants.prefTheme) ?? AppConstants.themeNetflixRed;
    notifyListeners();
  }

  Future<void> setTheme(String themeKey) async {
    if (!AppThemes.themes.containsKey(themeKey)) return;
    _currentTheme = themeKey;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefTheme, themeKey);
    notifyListeners();
  }
}
