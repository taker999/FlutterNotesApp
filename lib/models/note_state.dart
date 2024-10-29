import 'note.dart';

class NotesState {
  final List<Note> notes;
  final List<String> tags;

  NotesState({required this.notes, required this.tags});

  NotesState copyWith({
    List<Note>? notes,
    List<String>? tags,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
    );
  }
}
