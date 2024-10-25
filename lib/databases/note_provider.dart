import 'dart:convert';
import 'dart:developer';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notes_app/models/note.dart';

import 'database_provider.dart';
import 'database_service.dart';

// Define a state notifier for managing note
class NoteNotifier extends StateNotifier<Note> {
  NoteNotifier(this._databaseService) : super(Note(
    title: '',
    content: '',
    contentJson: '',
    dateCreated: 0,
    dateModified: 0,
    tags: null,
  ));

  final DatabaseService _databaseService;

  void addTag(String tag) {
    if(state.tags == null) {
      state.tags = [tag];
    } else {
      // Create a new list with the added tag
      final updatedTags = List<String>.from(state.tags!)..add(tag);

      // Create a new Note object with the updated tags
      final updatedNote = state.copyWith(tags: updatedTags);

      // Update the state with the new Note object
      state = updatedNote;
    }
  }



  Future<void> addNote(String title, Document content) async {
    final now = DateTime.now().microsecondsSinceEpoch;

    // Create the new note object
    final newNote = Note(
      title: title,
      content: content.toPlainText(),
      contentJson: jsonEncode(content.toDelta().toJson()),
      dateCreated: now,
      dateModified: now,
    );

    // Update the state directly
    state = newNote;  // Add the new note to the current state

    // Add the note to the database
    await _databaseService.addNote(newNote);
  }
}

// Create a provider for NoteNotifier
final noteProvider = StateNotifierProvider<NoteNotifier, Note>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return NoteNotifier(databaseService);
});
