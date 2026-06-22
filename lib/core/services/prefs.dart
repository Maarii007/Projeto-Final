import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _keyTheme  = 'theme_mode';
  static const _keyFilter = 'animal_filter';

  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode);
  }

  static Future<String> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme) ?? 'dark';
  }

  static Future<void> saveFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFilter, filter);
  }

  static Future<String> loadFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFilter) ?? 'all';
  }

  static ThemeMode toThemeMode(String value) =>
      value == 'light' ? ThemeMode.light : ThemeMode.dark;

  static String fromThemeMode(ThemeMode mode) =>
      mode == ThemeMode.light ? 'light' : 'dark';
}
