import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notes_app/models/note.dart';

import 'database_provider.dart';
import 'database_service.dart';
import 'notes_provider.dart';

// Define a state notifier for managing note
class NoteNotifier extends StateNotifier<Note> {
  NoteNotifier(this._databaseService, this._refreshNotes) : super(Note(
    title: '',
    content: '',
    contentJson: '',
    dateCreated: 0,
    dateModified: 0,
    tags: null,
  ));

  final DatabaseService _databaseService;
  final VoidCallback _refreshNotes;

  void addTag(String tag) {
    final currentTags = state.tags ?? [];
    // Check for duplicates
    if (!currentTags.contains(tag)) {
      final updatedTags = [...currentTags, tag];
      // Create a new Note object with updated tags
      state = state.copyWith(tags: updatedTags);
    }
  }

  Future<void> addNote(String title, List<String> tags, Document content) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Create the new note object
    final newNote = Note(
      title: title,
      content: content.toPlainText(),
      contentJson: jsonEncode(content.toDelta().toJson()),
      dateCreated: now,
      dateModified: now,
      tags: tags,
    );

    // Update the state directly
    state = newNote;  // Add the new note to the current state

    // Add the note to the database
    await _databaseService.addNote(newNote);

    // Call the refreshNotes callback to fetch the latest notes
    _refreshNotes();
  }

  Future<void> updateNote(int id, String title, List<String> tags, Document content) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Create the new note object
    final updatedNote = Note(
      id: id,
      title: title,
      content: content.toPlainText(),
      contentJson: jsonEncode(content.toDelta().toJson()),
      dateCreated: now,
      dateModified: now,
      tags: tags,
    );

    // Update the state directly
    state = updatedNote;  // Add the new note to the current state

    // Add the note to the database
    await _databaseService.updateNote(updatedNote);

    // Call the refreshNotes callback to fetch the latest notes
    _refreshNotes();
  }
}

// Create a provider for NoteNotifier
final noteProvider = StateNotifierProvider<NoteNotifier, Note>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  final notesNotifier = ref.watch(notesProvider.notifier);
  return NoteNotifier(databaseService , () {
    notesNotifier.fetchNotes(); // Callback to fetch notes
  });
});
