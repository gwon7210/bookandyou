import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'age_selection_page.dart'; // 나이 선택 페이지 import

class PasswordRegisterPage extends StatefulWidget {
  final String phoneNumber;

  const PasswordRegisterPage({super.key, required this.phoneNumber});

  @override
  _PasswordRegisterPageState createState() => _PasswordRegisterPageState();
}

class _PasswordRegisterPageState extends State<PasswordRegisterPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _registerUser() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final email = _emailController.text;
    final phoneNumber = widget.phoneNumber;

    if (password.isEmpty || confirmPassword.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 입력란을 작성해주세요.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      final response = await ApiService.post('/users', {
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
      }, includeAuth: false);

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        
        // JWT 토큰 저장
        final accessToken = responseBody['accessToken'];
        if (accessToken != null) {
          await ApiService.setToken(accessToken);
        } else {
          throw Exception('토큰이 없습니다');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공! 추가 정보를 입력해주세요.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AgeSelectionPage()),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${responseBody["message"]}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '비밀번호 등록',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '회원가입을 위해 비밀번호를 설정해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호 입력',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF4CAF50)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호 확인',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4CAF50)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: '이메일 입력 (비밀번호 찾기용)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email, color: Color(0xFF4CAF50)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}