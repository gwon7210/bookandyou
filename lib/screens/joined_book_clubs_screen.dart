
// screens/joined_book_clubs_screen.dart
import 'package:flutter/material.dart';
import '../models/book_club.dart';
import '../services/database_helper.dart';

class JoinedBookClubsScreen extends StatefulWidget {
  final int userId;

  JoinedBookClubsScreen({required this.userId});

  @override
  _JoinedBookClubsScreenState createState() => _JoinedBookClubsScreenState();
}

class _JoinedBookClubsScreenState extends State<JoinedBookClubsScreen> {
  List<BookClub> joinedBookClubs = [];

  @override
  void initState() {
    super.initState();
    _loadJoinedBookClubs();
  }

  Future<void> _loadJoinedBookClubs() async {
    final clubs = await DatabaseHelper.instance.getJoinedBookClubs(widget.userId);
    setState(() {
      joinedBookClubs = clubs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('참여한 독서 모임')),
      body: ListView.builder(
        itemCount: joinedBookClubs.length,
        itemBuilder: (context, index) {
          final club = joinedBookClubs[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(club.bookTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(club.description),
            ),
          );
        },
      ),
    );
  }
}