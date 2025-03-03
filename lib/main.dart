import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'pages/signup_page.dart';
import 'pages/phone_login_page.dart';
import 'pages/password_register_page.dart';
import 'pages/home_page.dart'; // 홈 페이지 import
import 'pages/login_page.dart'; // 로그인 페이지 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomePage(), // 웰컴 페이지를 메인 화면으로 설정
      routes: {
        '/signup': (context) => const SignupPage(), // 회원가입 페이지
        '/phone_login': (context) => const PhoneLoginPage(), // 휴대폰 로그인 페이지
        '/password_register': (context) => const PasswordRegisterPage(phoneNumber: ''), // 비밀번호 등록 페이지
        '/home': (context) => const HomePage(), // 홈 페이지 추가
        '/login': (context) => const LoginPage(), // ✅ 로그인 페이지 추가
      },
    );
  }
}
