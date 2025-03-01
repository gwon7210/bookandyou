import 'package:mysql1/mysql1.dart';
import '../models/user.dart';
import '../models/book_club.dart';

class MySqlService {
  MySqlService._privateConstructor();
  static final MySqlService instance = MySqlService._privateConstructor();

  static ConnectionSettings? _settings;
  static MySqlConnection? _conn;

  static Future<MySqlConnection> get connection async {
    if (_conn == null) {
      await instance._initialize();
    }
    return _conn!;
  }

  Future<void> _ensureConnection() async {
    if (_conn == null || _settings == null) {
      await _initialize();
    } else {
      try {
        await _conn!.query('SELECT 1');
      } catch (e) {
        print('연결 재설정 시도: $e');
        await _initialize();
      }
    }
  }

  Future<void> _initialize() async {
    final bool isEmulator = true;

    try {
      print('연결 설정 시작...');
      print('호스트: ${isEmulator ? '10.0.2.2' : '192.168.0.xxx'}');
      
      _settings = ConnectionSettings(
        host: isEmulator ? '10.0.2.2' : '192.168.0.xxx',
        port: 3306,
        user: 'bookandyou',
        password: '1212',
        db: 'bookandyou',
        timeout: Duration(seconds: 30),
      );
      
      print('MySQL 연결 시도 중...');
      if (_conn != null) {
        await _conn!.close();
      }
      _conn = await MySqlConnection.connect(_settings!);
      print('MySQL 연결 성공');
    } catch (e, stackTrace) {
      print('MySQL 연결 실패. 상세 에러:');
      print('에러 메시지: $e');
      print('스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  Future<User?> getUser(String username, String password) async {
    try {
      await _ensureConnection();  // 연결 상태 확인
      final results = await _conn!.query(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [username, password]
      );

      if (results.isNotEmpty) {
        final row = results.first;
        return User(
          id: row['id'],
          username: row['username'],
          password: row['password'],
          nickname: row['nickname'],
          age: row['age'],
          height: row['height'],
          favoriteBook: row['favorite_book'],
        );
      }
      return null;
    } catch (e) {
      print('사용자 조회 실패: $e');
      rethrow;
    }
  }

  Future<int> createUser(User user) async {
    try {
      await _ensureConnection();
      final result = await _conn!.query(
        'INSERT INTO users (username, password, nickname, age, height, favorite_book) VALUES (?, ?, ?, ?, ?, ?)',
        [user.username, user.password, user.nickname, user.age, user.height, user.favoriteBook]
      );
      return result.insertId ?? -1;
    } catch (e) {
      print('사용자 생성 실패: $e');
      rethrow;
    }
  }

  Future<List<BookClub>> getBookClubList([int? bookClubId]) async {
    try {
      await _ensureConnection();
      final results = await _conn!.query(
        '''
        SELECT * FROM book_clubs 
        '''
      );

      return results.map((row) => BookClub(
        id: row['id'],
        bookTitle: row['bookTitle'].toString(),
        description: row['description'].toString()
      )).toList();
    } catch (e) {
      print('북클럽 조회 실패: $e');
      rethrow;
    }
  }

  Future<void> joinBookClub(int userId, int bookClubId) async {
    try {
      await _ensureConnection();
      await _conn!.query(
        'INSERT INTO user_book_clubs (user_id, book_club_id) VALUES (?, ?)',
        [userId, bookClubId]
      );
    } catch (e) {
      print('북클럽 참여 실패: $e');
      rethrow;
    }
  }

Future<List<BookClub>> getJoinedBookClubs(int userId) async {
  try {
    await _ensureConnection();
    final results = await _conn!.query(
      '''
      SELECT bc.id, bc.bookTitle, bc.description
      FROM bookandyou.user_book_clubs ubc
      JOIN bookandyou.book_clubs bc ON ubc.book_club_id = bc.id
      WHERE ubc.user_id = ?
      ''', 
      [userId]
    );

    return results.map((row) => BookClub(
      id: row['id'],
      bookTitle: row['bookTitle'].toString(),
      description: row['description'].toString(),
    )).toList();
  } catch (e) {
    print('북클럽 조회 실패: $e');
    return [];
  }
}


  Future<void> close() async {
    await closeConnection();
  }

  static Future<void> closeConnection() async {
    if (_conn != null) {
      await _conn!.close();
      _conn = null;
    }
  }

  Future<void> initializeTables() async {
    try {
      await _ensureConnection();
      
      await _conn!.query('''
        CREATE TABLE IF NOT EXISTS users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          username VARCHAR(255) NOT NULL,
          password VARCHAR(255) NOT NULL,
          age INT NOT NULL,
          height DOUBLE NOT NULL,
          nickname VARCHAR(255) NOT NULL,
          favorite_book VARCHAR(255) NOT NULL
        )
      ''');

      await _conn!.query('''
        CREATE TABLE IF NOT EXISTS book_clubs (
          id INT AUTO_INCREMENT PRIMARY KEY,
          book_title VARCHAR(255) NOT NULL,
          description TEXT
        )
      ''');

      await _conn!.query('''
        CREATE TABLE IF NOT EXISTS user_book_clubs (
          id INT AUTO_INCREMENT PRIMARY KEY,
          user_id INT NOT NULL,
          book_club_id INT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id),
          FOREIGN KEY (book_club_id) REFERENCES book_clubs (id)
        )
      ''');
    } catch (e) {
      print('테이블 초기화 실패: $e');
      rethrow;
    }
  }

  Future<void> initialize() async {
    await _initialize();
    await initializeTables();  // 테이블도 함께 초기화
  }
} 