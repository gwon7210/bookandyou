import 'package:flutter/material.dart';
import '../services/mysql_service.dart';
import '../models/user.dart';
import 'main_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int age = 0;
  double height = 0.0;
  String nickname = '';
  String favoriteBook = '';

  Future<void> _registerUser() async {
    // 입력값 검증
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        age <= 0 ||
        height <= 0 ||
        nickname.isEmpty ||
        favoriteBook.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('모든 필드를 올바르게 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = User(
      username: _usernameController.text,
      password: _passwordController.text,
      age: age,
      height: height,
      nickname: nickname,
      favoriteBook: favoriteBook,
    );
    
    try {
      final userId = await MySqlService.instance.createUser(user);
      if (userId > 0) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => MainScreen(user: user))
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('회원가입 오류'),
            content: Text('MySQL 서버 오류가 발생했습니다. 나중에 다시 시도해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('회원가입 오류'),
          content: Text('오류가 발생했습니다: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: '아이디')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: '비밀번호'), obscureText: true),
            TextFormField(
              decoration: InputDecoration(
                labelText: '나이',
                hintText: '나이를 입력해주세요',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  age = int.tryParse(value) ?? 0;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '키',
                hintText: '키를 입력해주세요 (cm)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  height = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '닉네임',
                hintText: '닉네임을 입력해주세요',
              ),
              onChanged: (value) {
                setState(() {
                  nickname = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '좋아하는 책',
                hintText: '가장 좋아하는 책을 입력해주세요',
              ),
              onChanged: (value) {
                setState(() {
                  favoriteBook = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _registerUser, child: Text('회원가입')),
          ],
        ),
      ),
    );
  }
}