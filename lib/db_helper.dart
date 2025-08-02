import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  ///A
  ///singleton
  ///1
  DBHelper._();

  ///2
  static DBHelper getInstance() => DBHelper._();

  ///B
  ///Database
  Database? mDB;

  ///note table
  String noteTable = "note";
  static final String columnNoteId = "n_id";
  static final String columnNoteTitle = "n_title";
  static final String columnNoteDesc = "n_desc";
  static final String columnNoteCreatedAt = "n_created_at";

  ///initDB
  Future<Database> initDb() async {
    mDB ??= await openDB();
    return mDB!;
  }

  ///openDB
  Future<Database> openDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "noteDB.db");

    /// applicationDirPath/noteDB.db

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        ///create tables

        db.execute(
          "create table $noteTable ( $columnNoteId integer primary key autoincrement, $columnNoteTitle text, $columnNoteDesc text, $columnNoteCreatedAt text)",
        );
      },
    );
  }

  ///insert
  Future<bool> addNote({required String title, required String desc}) async{
    Database db = await initDb();
    int rowsEffected = await db.insert(noteTable, {
      columnNoteTitle : title,
      columnNoteDesc : desc,
      columnNoteCreatedAt : DateTime.now().millisecondsSinceEpoch.toString()
    });

    return rowsEffected > 0;
  }

  ///select
  Future<List<Map<String, dynamic>>> fetchAllNotes() async{

    Database db = await initDb();

    return db.query(noteTable);
  }

  ///update
  Future<bool> updateNote({required String updatedTitle, required String updatedDesc, required int id}) async{
    var db = await initDb();

    int rowsEffected = await db.update(noteTable, {
      columnNoteTitle : updatedTitle,
      columnNoteDesc : updatedDesc
    }, where: "$columnNoteId = ?", whereArgs: ["$id"]);

    return rowsEffected > 0;
  }
  ///delete
  Future<bool> deleteNote({required int id}) async{

    var db = await initDb();

    int rowsEffected = await db.delete(noteTable,where: "$columnNoteId = ?", whereArgs: ["$id"]);

    return rowsEffected > 0;
  }
}
