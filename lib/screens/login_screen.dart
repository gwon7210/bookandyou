// screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/user.dart';
import 'main_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    final user = await DatabaseHelper.instance.getUser(
      _usernameController.text, 
      _passwordController.text
    );
    if (user != null) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => MainScreen(user: user))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: 아이디 또는 비밀번호를 확인하세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser, 
              child: Text('로그인')
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SignupScreen())
                );
              },
              child: Text('회원가입')
            ),
          ],
        ),
      ),
    );
  }
}
