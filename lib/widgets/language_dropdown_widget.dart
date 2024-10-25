import 'dart:developer';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../languages/language_provider.dart';

class LanguageDropdownWidget extends ConsumerWidget {
  LanguageDropdownWidget({super.key});

  final List<Map<String, String>> dropdownOptions = [
    {'code': 'ar', 'name': 'عربي'},
    {'code': 'bn', 'name': 'বাংলা'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'española'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'it', 'name': 'Italiana'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'tr', 'name': 'Türkçe'},
    {'code': 'zh', 'name': '中国人'}
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build lang dropdown widget');

    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.changeLanguage,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          DropdownButton(
            underline: SizedBox.shrink(),
            isDense: true,
            value: language,
            icon: const Icon(Icons.arrow_drop_down),
            items: dropdownOptions
                .map((e) => DropdownMenuItem(
                    value: e['code'],
                    child: Row(
                      children: [
                        if (language == e['code']) ...[
                          Icon(Icons.check, color: Colors.green),
                          SizedBox(width: 8)
                        ],
                        Text(e['name'].toString()),
                      ],
                    )))
                .toList(),
            selectedItemBuilder: (context) => dropdownOptions.map((e) => Text(e['name'].toString())).toList(),
            onChanged: (lang) {
              if (lang != null) {
                ref
                    .read(languageProvider.notifier)
                    .changeLanguage(lang);
              }
            },
          ),
        ],
      ),
    );
  }
}
