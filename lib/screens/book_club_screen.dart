// screens/book_club_screen.dart
import 'package:flutter/material.dart';
import '../models/book_club.dart';
import 'book_club_detail_screen.dart';
import '../models/user.dart';

class BookClubScreen extends StatelessWidget {
  final User user;
  BookClubScreen({required this.user});
  
  final List<BookClub> bookClubs = [
    BookClub(id: 1, bookTitle: '해리 포터', description: '마법과 판타지를 좋아하는 모임'),
    BookClub(id: 2, bookTitle: '데미안', description: '성장과 철학을 이야기하는 모임'),
    BookClub(id: 3, bookTitle: '1984', description: '디스토피아와 사회 비판을 논하는 모임'),
    BookClub(id: 4, bookTitle: '호밀밭의 파수꾼', description: '청춘과 방황을 나누는 모임'),
    BookClub(id: 5, bookTitle: '이방인', description: '실존주의를 탐구하는 모임'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('독서 모임 선택')),
      body: ListView.builder(
        itemCount: bookClubs.length,
        itemBuilder: (context, index) {
          final club = bookClubs[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(club.bookTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(club.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookClubDetailScreen(bookClub: club, userId: user.id!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}