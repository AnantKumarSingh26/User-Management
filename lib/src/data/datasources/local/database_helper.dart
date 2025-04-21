import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = "UserManagement.db";
  static const _databaseVersion = 1;

  static const table = 'users';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnEmail = 'email';

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed.
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database (and create it if it doesn't exist).
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnEmail TEXT NOT NULL UNIQUE
          )
          ''');
  }

  // --- CRUD Methods ---

  // Insert a user into the database.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    try {
       return await db.insert(table, row);
    } catch (e) {
        print("Error inserting user: $e");
        // Consider throwing a more specific exception or handling duplicates
        if (e.toString().contains('UNIQUE constraint failed')) {
           throw Exception('Email already exists');
        }
        throw Exception('Failed to insert user');
    }
  }

  // Query a single user by ID.
   Future<Map<String, dynamic>?> queryUser(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Query all users.
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query(table, orderBy: '$columnName ASC');
  }

  // Update a user.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
     try {
        return await db.update(
            table,
            row,
            where: '$columnId = ?',
            whereArgs: [id],
        );
     } catch (e) {
        print("Error updating user: $e");
        // Consider throwing a more specific exception or handling duplicates
        if (e.toString().contains('UNIQUE constraint failed')) {
           throw Exception('Email already exists');
        }
        throw Exception('Failed to update user');
    }
  }

  // Delete a user.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

   // Optional: Close the database when done (usually not needed in Flutter apps
   // unless you have specific requirements for resource management)
   Future close() async {
     final db = await instance.database;
     _database = null; // Allow re-initialization if needed later
     db.close();
   }
}