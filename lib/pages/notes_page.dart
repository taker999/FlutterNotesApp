import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/grid_view_widget.dart';
import '../widgets/tags_list_view_widget.dart';
import 'note_details_page.dart';
import 'settings_page.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('build notes');

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(localizations.notes),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsPage()),
            ),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteDetailsPage(),
          ),
        ),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          TagsListViewWidget(),
          GridViewWidget(),
        ],
      ),
    );
  }
}
