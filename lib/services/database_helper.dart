// // services/database_helper.dart
// import 'package:mysql1/mysql1.dart';
// import '../models/user.dart';
// import '../models/book_club.dart';
// import '../services/mysql_service.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static MySqlConnection? _connection;

//   DatabaseHelper._init();

//   Future<MySqlConnection> get connection async {
//     if (_connection != null) return _connection!;
//     _connection = await _initDB();
//     return _connection!;
//   }

//   Future<MySqlConnection> _initDB() async {
//     final settings = ConnectionSettings(
//       host: 'localhost',
//       port: 3306,
//       user: 'bookandyou',
//       password: '1212',
//       db: 'bookandyou_db'
//     );

//     return await MySqlConnection.connect(settings);
//   }

//   Future<void> initializeTables() async {
//     final conn = await connection;
    
//     await conn.query('''
//       CREATE TABLE IF NOT EXISTS users (
//         id INT AUTO_INCREMENT PRIMARY KEY,
//         username VARCHAR(255) NOT NULL,
//         password VARCHAR(255) NOT NULL,
//         age INT NOT NULL,
//         height DOUBLE NOT NULL,
//         nickname VARCHAR(255) NOT NULL,
//         favoriteBook VARCHAR(255) NOT NULL
//       )
//     ''');

//     await conn.query('''
//       CREATE TABLE IF NOT EXISTS joined_book_clubs (
//         id INT AUTO_INCREMENT PRIMARY KEY,
//         user_id INT NOT NULL,
//         book_club_id INT NOT NULL,
//         FOREIGN KEY (user_id) REFERENCES users (id),
//         FOREIGN KEY (book_club_id) REFERENCES book_clubs (id)
//       )
//     ''');
//   }

//   Future<int> joinBookClub(int userId, int bookClubId) async {
//     final conn = await connection;
//     var result = await conn.query(
//       'INSERT INTO joined_book_clubs (user_id, book_club_id) VALUES (?, ?)',
//       [userId, bookClubId]
//     );
//     return result.insertId ?? -1;
//   }

//   Future<List<BookClub>> getJoinedBookClubs(int userId) async {
//     final conn = await connection;
//     var results = await conn.query('''
//       SELECT bc.id, bc.bookTitle, bc.description 
//       FROM book_clubs bc
//       JOIN joined_book_clubs jbc ON bc.id = jbc.book_club_id
//       WHERE jbc.user_id = ?
//     ''', [userId]);

//     return results.map((row) => BookClub.fromMap({
//       'id': row[0],
//       'bookTitle': row[1],
//       'description': row[2],
//     })).toList();
//   }

//   Future<User?> getUser(String username, String password) async {
//     final conn = await connection;
//     var results = await conn.query(
//       'SELECT * FROM users WHERE username = ? AND password = ?',
//       [username, password]
//     );

//     if (results.isNotEmpty) {
//       final row = results.first;
//       return User.fromMap({
//         'id': row[0],
//         'username': row[1],
//         'password': row[2],
//         'age': row[3],
//         'height': row[4],
//         'nickname': row[5],
//         'favoriteBook': row[6],
//       });
//     }
//     return null;
//   }

//   Future<int> createUser(User user) async {
//     final conn = await connection;
//     var result = await conn.query(
//       '''INSERT INTO users 
//          (username, password, age, height, nickname, favoriteBook)
//          VALUES (?, ?, ?, ?, ?, ?)''',
//       [
//         user.username,
//         user.password,
//         user.age,
//         user.height,
//         user.nickname,
//         user.favoriteBook
//       ]
//     );
//     return result.insertId ?? -1;
//   }

//   Future<void> close() async {
//     final conn = await connection;
//     await conn.close();
//   }

//   Future<T> executeWithRetry<T>(Future<T> Function() operation) async {
//     try {
//       return await operation();
//     } on SocketException catch (e) {
//       // 연결이 끊어진 경우 재시도
//       await MySqlService.closeConnection();
//       return await operation();
//     } catch (e) {
//       throw e;
//     }
//   }
  
//   Future<void> query(String sql) async {
//     await executeWithRetry(() async {
//       final conn = await MySqlService.connection;
//       return await conn.query(sql);
//     });
//   }
// }