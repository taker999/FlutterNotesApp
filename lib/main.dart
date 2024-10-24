import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'languages/language_provider.dart';
import 'pages/notes_page.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final themeData = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Notes',
      theme: themeData,
      locale: Locale(language),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar'),
        Locale('bn'),
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('ja'),
        Locale('pt'),
        Locale('ru'),
        Locale('tr'),
        Locale('zh'),
      ],
      home: NotesPage(),
    );
  }
}
