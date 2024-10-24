import 'dart:developer';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../widgets/language_dropdown_widget.dart';
import '../widgets/toggle_theme_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('build settings');

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          localizations.settings,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          ToggleThemeWidget(),  // This widget will rebuild when the theme changes
          LanguageDropdownWidget(),  // This widget will rebuild when the language changes
        ],
      ),
    );
  }
}
