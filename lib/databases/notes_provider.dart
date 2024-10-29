import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note_state.dart';
import 'database_provider.dart';
import 'database_service.dart';


// Define a state notifier for managing notes
class NotesNotifier extends StateNotifier<NotesState> {
  NotesNotifier(this._databaseService)
      : super(NotesState(notes: [], tags: []));

  final DatabaseService _databaseService;

  Future<void> fetchNotes() async {
    final notes = await _databaseService.getNotes();
    state = state.copyWith(notes: notes); // Update only notes
  }

  Future<void> getTags() async {
    final tags = await _databaseService.getTags();
    state = state.copyWith(tags: tags); // Update only tags
  }
}

// Create a provider for NotesNotifier
final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return NotesNotifier(databaseService)..fetchNotes()..getTags();
});
