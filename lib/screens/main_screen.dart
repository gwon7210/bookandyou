// screens/main_screen.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'joined_book_clubs_screen.dart';
import 'book_club_screen.dart';

class MainScreen extends StatelessWidget {
  final User user;

  MainScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인 페이지')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임: ${user.nickname}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('좋아하는 책: ${user.favoriteBook}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookClubScreen(user: user)),
                );
              },
              child: Text('독서 모임 선택'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinedBookClubsScreen(userId: user.id!)),
                );
              },
              child: Text('참여한 독서 모임 보기'),
            ),
          ],
        ),
      ),
    );
  }
}