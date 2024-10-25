import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notes_app/models/note.dart';

import 'database_provider.dart';
import 'database_service.dart';

// Define a state notifier for managing notes
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier(this._databaseService) : super([]);

  final DatabaseService _databaseService;

  Future<void> fetchNotes() async {
    final notes = await _databaseService.getNotes();
    state = notes;
  }
}

// Create a provider for NotesNotifier
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return NotesNotifier(databaseService)..fetchNotes();
});
