import 'package:ditonton/data/models/movie/movie_table.dart';
import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;
  static const String _tableWatchlistMovie = 'watchlist_movie';
  static const String _tableWatchlistTv = 'watchlist_tv';

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tableWatchlistMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    await db.execute('''
    CREATE TABLE $_tableWatchlistTv (
      id INTEGER PRIMARY KEY,
      name TEXT,
      overview TEXT,
      posterPath TEXT
    );
  ''');
  }

  /*
  * Movies
  * */
  Future<int> insertWatchlistMovie(MovieTable movieTable) async {
    final db = await database;
    return await db!.insert(_tableWatchlistMovie, movieTable.toJson());
  }

  Future<int> removeWatchlistMovie(MovieTable movieTable) async {
    final db = await database;
    return await db!
        .delete(_tableWatchlistMovie, where: 'id = ?', whereArgs: [movieTable.id]);
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tableWatchlistMovie,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tableWatchlistMovie);

    return results;
  }

  /*
  * Tv Series
  * */
  Future<int> insertWatchlistTv(TvTable tvTable) async {
    final db = await database;
    return await db!.insert(_tableWatchlistTv, tvTable.toJson());
  }

  Future<int> removeWatchlistTv(TvTable tvTable) async {
    final db = await database;
    return await db!
        .delete(_tableWatchlistTv, where: 'id = ?', whereArgs: [tvTable.id]);
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tableWatchlistTv,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTv() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tableWatchlistTv);

    return results;
  }
}
