import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/movie.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblMovie = "movie";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DbHelper._internal();

  factory DbHelper(){
    return _dbHelper;
  }


  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "movie.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = "CREATE TABLE $tblMovie($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
        "$colDescription TEXT,$colPriority INTEGER, $colDate TEXT)";
    await db.execute(sql);
  }

  Future<int> insertMovie(Movie movie) async {
    Database db = await this.db;
    var result = await db.insert(tblMovie, movie.toMap());
    return result;
  }

  Future<List> getMovies() async {
    Database db = await this.db;
    var result = await db.rawQuery(
        "SELECT * from $tblMovie order by $colPriority DESC");
    return result;
  }

  Future<int> getCount(Movie movie) async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tblMovie")
    );

    return result;
  }

  Future<int> updateMovie(Movie movie) async {
    Database db = await this.db;
    var result = await db.update(
        tblMovie, movie.toMap(), where: "$colId = ?", whereArgs: [movie.id]);
    return result;
  }

  Future<int> deleteMovie(int id) async {
    Database db = await this.db;
    int result;
    result = await db.rawDelete("DELETE FROM $tblMovie WHERE $colId = $id");
    return result;
  }

}