import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_screen.dart';
import 'screens/book_club_screen.dart';
import 'screens/joined_book_clubs_screen.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Meetup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/main') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => MainScreen(user: user),
          );
        } else if (settings.name == '/book_club') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => BookClubScreen(user: user),
          );
        } else if (settings.name == '/joined_book_clubs') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => JoinedBookClubsScreen(userId: userId),
          );
        }
        return null;
      },
    );
  }
}
