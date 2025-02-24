import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_screen.dart';
import 'screens/book_club_screen.dart';
import 'screens/joined_book_clubs_screen.dart';
import 'models/user.dart';
import 'services/mysql_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await MySqlService.instance.initializeTables();
    runApp(MyApp());
  } catch (e) {
    print('데이터베이스 초기화 실패: $e');
  }
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    MySqlService.instance.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      MySqlService.instance.close();
    }
  }

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
      navigatorObservers: [
        RouteObserver(),
      ],
    );
  }
}
