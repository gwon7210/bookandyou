import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../widgets/common/common_bottom_navigation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void _onItemTapped(int index) {
    NavigationService.handleNavigation(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '채팅',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          '채팅 기능 준비 중입니다.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigation(
        selectedIndex: 2,
        onItemTapped: _onItemTapped,
      ),
    );
  }
} 