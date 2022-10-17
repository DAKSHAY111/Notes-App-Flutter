import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/myNoteModel.dart';
import 'package:notes_app/services/firestore_db.dart';

//* Sqflite Local databse operation function

class NotesDatabse {
  static final NotesDatabse instance = NotesDatabse._init();
  static Database? _database;
  NotesDatabse._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Notes_app.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // * Create Table Query

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = ' BOOLEAN NOT NULL';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE Notes(
      ${NoteFields.id} $idType,
      ${NoteFields.uniqueId} $textType,
      ${NoteFields.pin} $boolType,
      ${NoteFields.isArchive} $boolType,
      ${NoteFields.title} $textType,
      ${NoteFields.content} $textType,
      ${NoteFields.color} $textType,
      ${NoteFields.createdTime} $textType
    )
    ''');
  }

  //* Create Note Entry in Databse

  Future<Note?> InsertEntry(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(NoteFields.tableName, note.toJson());

    //* Storing in firebase
    await FireDB().createNewNoteFirestore(note);

    print("Note added $id");
    return note.copy(id: id);
  }

  //* Read Note Entry from Databse

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.createdTime} DESC';
    final queryResult = await db!.query(NoteFields.tableName,
        orderBy: orderBy,
        where: '${NoteFields.isArchive} = 0 and ${NoteFields.pin}=0');
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readAllArchiveNotes() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.createdTime} DESC';
    final queryResult = await db!.query(NoteFields.tableName,
        orderBy: orderBy, where: '${NoteFields.isArchive} = 1');
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readAllPinNotes() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.createdTime} DESC';
    final queryResult = await db!.query(NoteFields.tableName,
        orderBy: orderBy, where: '${NoteFields.pin} = 1');
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NoteFields.tableName,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  // Future<List<int>> getNoteString(String query) async {
  //   final db = await instance.database;
  //   final result = await db!.query(NoteFields.tableName);
  //   List<int> resultIds = [];
  //   result.forEach((element) {
  //     if (element["title"].toString().toLowerCase().contains(query) ||
  //         element["content"].toString().toLowerCase().contains(query)) {
  //       resultIds.add(element["id"] as int);
  //     }
  //   });

  //   return resultIds;
  // }
  //* Update Note in Databse

  Future updateNote(Note note) async {
    await FireDB().updateNoteFirestore(note);

    final db = await instance.database;
    await db!.update(NoteFields.tableName, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
    print("Note update");
  }

  // * Pin Note Feature

  Future pinNote(Note? note) async {
    print("Request for pin: ${note!.id} before : ${note.pin}");
    final db = await instance.database;
    await db!.update(NoteFields.tableName, {NoteFields.pin: !note.pin ? 0 : 1},
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
    print("Note pinned for ${note.id}");
  }

// * Achieve Note Feature

  Future archiveNote(Note? note) async {
    print("Request for pin: ${note!.isArchive} before : ${note.isArchive}");
    final db = await instance.database;
    await db!.update(
        NoteFields.tableName, {NoteFields.isArchive: !note.isArchive ? 0 : 1},
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);

    print("Note pinned for ${note.id}");
  }

//* Delete Note from Local Storage

  Future delteNote(Note note) async {
    //! Bcz we are not deleting note from database server
    //! await FireDB().deleteNoteFirestore(note);

    final db = await instance.database;
    await db!.delete(NoteFields.tableName,
        where: '${NoteFields.id}= ?', whereArgs: [note.id]);
  }

  Future closeDB() async {
    final db = await instance.database;
    db!.close();
  }
}
