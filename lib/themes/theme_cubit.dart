import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialx/themes/dark_mode.dart';
import 'package:socialx/themes/light_mode.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static const String _themePreferenceKey = 'isDarkMode';
  bool _isDarkMode = false;

  ThemeCubit() : super(lightMode) {
    _loadThemeState();
  }

  bool get isDarkMode => _isDarkMode;

  /// Toggles and save locally
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    if (_isDarkMode) {
      emit(darkMode);
    } else {
      emit(lightMode);
    }
    await _saveThemeState();
  }

  Future<void> _saveThemeState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);
  }

  Future<void> _loadThemeState() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    if (_isDarkMode) {
      emit(darkMode);
    } else {
      emit(lightMode);
    }
  }
}
