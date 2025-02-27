// screens/book_club_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/book_club.dart';
import '../services/mysql_service.dart';

class BookClubDetailScreen extends StatelessWidget {
  final BookClub bookClub;
  final int userId;

  const BookClubDetailScreen({
    Key? key,
    required this.bookClub,
    required this.userId,
  }) : super(key: key);

  Future<void> _joinBookClub(BuildContext context) async {
    await MySqlService.instance.joinBookClub(userId, bookClub.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${bookClub.bookTitle} 모임에 참여했습니다!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookClub.bookTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bookClub.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _joinBookClub(context),
              child: Text('참여하기'),
            ),
          ],
        ),
      ),
    );
  }
}