import 'package:flutter/material.dart';
import '../pages/open_bookclubs_page.dart';
import '../pages/my_bookclubs_page.dart';
import '../pages/chat_page.dart';
import '../pages/profile_page.dart';

class NavigationService {
  static void handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0: // 홈
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OpenBookclubsPage()),
          (route) => false,
        );
        break;
      case 1: // 내 북클럽
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyBookclubsPage()),
        );
        break;
      case 2: // 채팅
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
        break;
      case 3: // 프로필
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }
} 