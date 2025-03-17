import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../widgets/common/common_bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          '프로필',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          '프로필 기능 준비 중입니다.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigation(
        selectedIndex: 3,
        onItemTapped: _onItemTapped,
      ),
    );
  }
} 