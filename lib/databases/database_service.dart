import 'dart:developer';

import 'package:flutter_notes_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    // open the database
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('''CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            contentJson TEXT,
            dateCreated INTEGER,
            dateModified INTEGER);''');
        await db.execute('''CREATE TABLE tags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT);''');
        await db.execute('''CREATE TABLE note_tags (
            note_id INTEGER,
            tag_id INTEGER,
            FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE,
            FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE);''');
      },
    );
    return database;
  }

  Future<void> addNote(Note note) async {
    final db = await database;

    // Start a transaction to ensure data integrity
    await db.transaction((txn) async {
      // Insert the note
      final noteId = await txn.insert(
        'notes',
        {
          "title": note.title,
          "content": note.content,
          "contentJson": note.contentJson,
          "dateCreated": note.dateCreated,
          "dateModified": note.dateModified,
        },
      );

      // Insert associated tags and create entries in note_tags
      if (note.tags != null) {
        for (var tag in note.tags!) {
          // Insert tag if it doesn't exist
          final tagId = await txn.insert(
            'tags',
            {
              "name": tag,
            },
            conflictAlgorithm:
                ConflictAlgorithm.ignore, // Prevent duplicate tags
          );

          // Associate tag with the note
          await txn.insert(
            'note_tags',
            {
              "note_id": noteId,
              "tag_id": tagId,
            },
          );
        }
      }
    });
  }

  Future<List<Note>> getNotes() async {
    final db = await database;

    // Get all notes
    final notesData = await db.query("notes");

    // Prepare the list to hold notes
    List<Note> notes = [];

    for (var note in notesData) {
      final noteId = note['id'];

      // Get associated tags for each note
      final tagsData = await db.rawQuery('''
      SELECT tags.name
      FROM tags
      INNER JOIN note_tags ON tags.id = note_tags.tag_id
      WHERE note_tags.note_id = ?
    ''', [noteId]);

      // Extract tag names
      List<String> tags = tagsData.map((tag) => tag['name'] as String).toList();

      // Create a Note object and add it to the list
      notes.add(Note(
        id: note['id'] as int,
        title: note['title'].toString(),
        content: note['content'].toString(),
        contentJson: note['contentJson'].toString(),
        dateCreated: note['dateCreated'] as int,
        dateModified: note['dateModified'] as int,
        tags: tags.isNotEmpty ? tags : null,
      ));
    }

    return notes;
  }

  Future<void> updateNote(Note updatedNote) async {
    final db = await database;

    // Start a transaction to ensure data integrity
    await db.transaction((txn) async {
      // Update the note
      await txn.update(
        'notes',
        {
          "title": updatedNote.title,
          "content": updatedNote.content,
          "contentJson": updatedNote.contentJson,
          "dateModified": updatedNote.dateModified,
        },
        where: "id = ?",
        whereArgs: [updatedNote.id],
      );

      // Clear existing associations in note_tags for this note
      await txn.delete(
        'note_tags',
        where: "note_id = ?",
        whereArgs: [updatedNote.id],
      );

      // Insert associated tags and create new entries in note_tags
      if (updatedNote.tags != null && updatedNote.tags!.isNotEmpty) {
        for (var tag in updatedNote.tags!) {
          // Insert tag if it doesn't exist
          final tagId = await txn.insert(
            'tags',
            {
              "name": tag,
            },
            conflictAlgorithm:
                ConflictAlgorithm.ignore, // Prevent duplicate tags
          );

          // Associate tag with the note
          await txn.insert(
            'note_tags',
            {
              "note_id": updatedNote.id,
              "tag_id": tagId,
            },
          );
        }
        // delete tags that are not associated with any notes
        await txn.rawDelete('''
        DELETE FROM tags
        WHERE id NOT IN (SELECT tag_id FROM note_tags);
      ''');
      }
    });
  }

  Future<void> deleteNote(int id) async {
    final db = await database;

    // Start a transaction to ensure data integrity
    await db.transaction((txn) async {
      // Delete from note_tags where note_id matches
      await txn.delete(
        "note_tags",
        where: "note_id = ?",
        whereArgs: [id],
      );

      // Delete the note itself
      await txn.delete(
        "notes",
        where: "id = ?",
        whereArgs: [id],
      );

      // delete tags that are not associated with any notes
      await txn.rawDelete('''
        DELETE FROM tags
        WHERE id NOT IN (SELECT tag_id FROM note_tags);
      ''');
    });
  }

  Future<List<String>> getTags() async {
    final db = await database;

    // Query the tags table to get all tag names
    final List<Map<String, dynamic>> tagsData = await db.query('tags');

    // Extract tag names into a List<String>
    List<String> tags = tagsData.map((tag) => tag['name'] as String).toList();

    return tags;
  }

}
