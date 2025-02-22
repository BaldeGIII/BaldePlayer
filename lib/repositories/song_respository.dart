import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/song.dart';

class SongRepository {
  static const String tableName = 'songs';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'music_player.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        title TEXT,
        artist TEXT,
        album TEXT,
        url TEXT,
        duration INTEGER
      )
    ''');
  }

  Future<int> insertSong(Song song) async {
    Database db = await database;
    return await db.insert(tableName, song.toMap());
  }

  Future<List<Song>> getAllSongs() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }

  Future<int> updateSong(Song song) async {
    Database db = await database;
    return await db.update(
      tableName,
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  Future<int> deleteSong(String id) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Song>> searchSongs(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'title LIKE ? OR artist LIKE ? OR album LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }

  Future<List<Song>> getSortedSongs(String sortBy) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: sortBy,
    );
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }

  Future<List<Song>> getSongsByArtist(String artist) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'artist = ?',
      whereArgs: [artist],
    );
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }

  Future<List<Song>> getSongsByAlbum(String album) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'album = ?',
      whereArgs: [album],
    );
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }
}
