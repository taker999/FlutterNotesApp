import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  // initial state
  ThemeNotifier() : super(lightMode) {
    _loadTheme();
  }

  // Load the theme from SharedPreferences
  Future<void> _loadTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final isDark = sharedPreferences.getBool('isDark') ?? false; // Default to false if not set
    state = isDark ? darkMode : lightMode;
  }

  // methods to update state
  Future<void> toggleTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (state == lightMode) {
      state = darkMode;
      await sharedPreferences.setBool('isDark', true);
    } else {
      state = lightMode;
      await sharedPreferences.setBool('isDark', false);
    }
  }
}


final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
