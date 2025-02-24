// screens/book_club_screen.dart
import 'package:flutter/material.dart';
import '../models/book_club.dart';
import 'book_club_detail_screen.dart';
import '../models/user.dart';
import '../services/mysql_service.dart';

class BookClubScreen extends StatelessWidget {
  final User user;
  BookClubScreen({required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('독서 모임 선택')),
      body: FutureBuilder<List<BookClub>>(
        future: MySqlService.instance.getJoinedBookClubs(user.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('북클럽 정보를 불러오는데 실패했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('참여 중인 북클럽이 없습니다.'));
          } else {
            final bookClubs = snapshot.data!;
            return ListView.builder(
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
            );
          }
        },
      ),
    );
  }
}