import 'package:flutter/material.dart';
import '../pages/open_bookclubs_page.dart';
import '../pages/my_bookclubs_page.dart';
import '../pages/chat_page.dart';
import '../pages/profile_page.dart';

class NavigationService {
  static void handleNavigation(BuildContext context, int index) {
    Widget page;
    String routeName;

    switch (index) {
      case 0:
        page = const OpenBookclubsPage();
        routeName = "/home";
        break;
      case 1:
        page = const MyBookclubsPage();
        routeName = "/mybookclubs";
        break;
      case 2:
        page = const ChatPage();
        routeName = "/chat";
        break;
      case 3:
        page = const ProfilePage();
        routeName = "/profile";
        break;
      default:
        return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(name: routeName),
      ),
      (route) => false, // 스택을 완전히 비우고 새로운 페이지만 남김
    );
  }
}
