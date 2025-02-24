// models/user.dart
class User {
  int? id;
  String username;
  String password;
  int age;
  double height;
  String nickname;
  String favoriteBook;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.age,
    required this.height,
    required this.nickname,
    required this.favoriteBook,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'age': age,
      'height': height,
      'nickname': nickname,
      'favoriteBook': favoriteBook,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      age: map['age'],
      height: map['height'],
      nickname: map['nickname'],
      favoriteBook: map['favoriteBook'],
    );
  }
}