import 'dart:developer';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes_app/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';

class ToggleThemeWidget extends ConsumerWidget {
  const ToggleThemeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build toggle theme widget');

    final themeData = ref.watch(themeNotifierProvider);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.darkMode,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          CupertinoSwitch(
            value: themeData == darkMode ? true : false,
            onChanged: (value) {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
