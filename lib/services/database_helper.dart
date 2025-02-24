
// services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/book_club.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        age INTEGER NOT NULL,
        height REAL NOT NULL,
        nickname TEXT NOT NULL,
        favoriteBook TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE joined_book_clubs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        book_club_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (book_club_id) REFERENCES book_clubs (id)
      )
    ''');
  }

  Future<int> joinBookClub(int userId, int bookClubId) async {
    final db = await instance.database;
    return await db.insert('joined_book_clubs', {
      'user_id': userId,
      'book_club_id': bookClubId,
    });
  }

  Future<List<BookClub>> getJoinedBookClubs(int userId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT bc.id, bc.bookTitle, bc.description FROM book_clubs bc
      JOIN joined_book_clubs jbc ON bc.id = jbc.book_club_id
      WHERE jbc.user_id = ?
    ''', [userId]);

    return result.map((map) => BookClub.fromMap(map)).toList();
  }

  Future<User?> getUser(String username, String password) async {
  final db = await instance.database;
  final maps = await db.query(
    'users',
    where: 'username = ? AND password = ?',
    whereArgs: [username, password],
  );

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  }
  return null;
}
  
  Future<int> createUser(User user) async {
  final db = await instance.database;
  return await db.insert('users', user.toMap());
}

}