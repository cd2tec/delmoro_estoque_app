import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, 'app_database.db');

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE tokens(id INTEGER PRIMARY KEY, user TEXT, token TEXT )',
        );
      },
    );
  }

  static Future<String?> getToken(String user) async {
    final Database database = await initializeDatabase();

    List<Map<String, dynamic>> tokens = await database.query(
      'tokens',
      where: 'user = ?',
      whereArgs: [user],
    );

    if (tokens.isNotEmpty) {
      return tokens.first['token'] as String?;
    } else {
      return null;
    }
  }

  static Future<void> deleteToken() async {
    final Database database = await initializeDatabase();
    await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
    );

    await database.delete('tokens');
    List<Map<String, dynamic>> tokens = await database.query(
      'tokens',
    );
  }

  static Future<void> saveToken(String user, String token) async {
    final Database database = await initializeDatabase();

    await database.insert(
      'tokens',
      {'user': user, 'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
