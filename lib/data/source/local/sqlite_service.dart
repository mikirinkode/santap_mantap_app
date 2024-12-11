import 'package:santap_mantap_app/data/model/restaurant_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'santap_mantap.db';
  static const int _databaseVersion = 1;
  static const String _tableName = "restaurant";

  Future<Database> _initializeDatabase() async {
    return openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<void> insertRestaurant(RestaurantModel restaurant) async {
    final db = await _initializeDatabase();
    final data = restaurant.toJson();
    await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeRestaurant(String id) async {
    final db = await _initializeDatabase();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> contain(String id) async {
    final db = await _initializeDatabase();
    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    final db = await _initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (index) {
      return RestaurantModel.fromJson(maps[index]);
    });
  }
}
