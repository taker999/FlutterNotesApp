import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<String> {
  // initial state
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  // Load the language from SharedPreferences
  Future<void> _loadLanguage() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    state = sharedPreferences.getString('language') ?? 'en';
  }

  // methods to update state
  Future<void> changeLanguage(String lang) async {
    if (state != lang) {
      final sharedPreferences = await SharedPreferences.getInstance();
      state = lang;
      await sharedPreferences.setString('language', lang);
    }
  }
}

final languageNotifierProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});
