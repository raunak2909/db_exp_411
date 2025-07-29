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
          "create table note ( n_id integer primary key autoincrement, n_title text, n_desc text, n_created_at text)",
        );
      },
    );
  }

  ///insert
  Future<bool> addNote({required String title, required String desc}) async{
    Database db = await initDb();
    int rowsEffected = await db.insert("note", {
      "n_title": title,
      "n_desc": desc,
      "n_created_at" : DateTime.now().millisecondsSinceEpoch.toString()
    });

    return rowsEffected > 0;
  }

  ///select
  Future<List<Map<String, dynamic>>> fetchAllNotes() async{

    Database db = await initDb();

    return db.query("note");
  }
}
