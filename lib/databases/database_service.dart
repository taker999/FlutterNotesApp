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
    await db.insert(
      'notes',
      {
        "title": note.title,
        "content": note.content,
        "contentJson": note.contentJson,
        "dateCreated": note.dateCreated,
        "dateModified": note.dateModified,
      },
    );
    for (var tag in note.tags!) {
      await db.insert(
        'tags',
        {
          "name": tag,
        },
      );
    }
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

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      "notes",
      where: "id = ?",
      whereArgs: [
        id,
      ],
    );
    await db.rawDelete('''
      DELETE FROM tags
      WHERE id IN (
      SELECT id FROM tags
      WHERE id NOT IN (SELECT tag_id FROM note_tags)
    );''');
  }
}
