import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  //Create a single db instance (Singleton)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  //Get db. If it doesn't exist, create it
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('focus_quest.db');
    return _database!;
  }

  //Init db in phone system physical path
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _createDB
    );
  }

  //Create user table
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        level INTEGER,
        current_xp INTEGER
      )
    ''');

    //Starting default lvl 1 user
    await db.insert('user', {
      'name': 'Eroe dello Studio',
      'level': 1,
      'current_xp': 0,
    });
  }

  //Read user data from db
  Future<Map<String, dynamic>?> getUserData() async {
    final db = await instance.database;

    //get all users
    final maps = await db.query('user');

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  //update user's lvl and exp
  Future<int> updateUser(int newLevel, int newXp) async {
    final db = await instance.database;

    return await db.update(
      'user',
      {
        'level': newLevel,
        'current_xp': newXp,
      },
      where: 'id = ?',
      whereArgs: [1], //always update user with ID = 1
    );
  }
}