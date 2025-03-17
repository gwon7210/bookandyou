import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookandyou/widgets/common/common_bottom_navigation.dart';
import 'create_bookclub_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookandyou/services/navigation_service.dart';

class MyBookclubsPage extends StatefulWidget {
  const MyBookclubsPage({super.key});

  @override
  State<MyBookclubsPage> createState() => _MyBookclubsPageState();
}

class _MyBookclubsPageState extends State<MyBookclubsPage> {
  List<dynamic> _myBookclubs = [];
  bool _isLoading = true;
  String _errorMessage = '';

  void _onItemTapped(int index) {
    NavigationService.handleNavigation(context, index);
  }

  @override
  void initState() {
    super.initState();
    _fetchMyBookclubs();
  }

  Future<void> _fetchMyBookclubs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/mybookclubs'));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          _myBookclubs = decodedData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = '데이터를 불러오는데 실패했습니다: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '내 북클럽',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? _buildErrorUI()
                    : _myBookclubs.isEmpty
                        ? _buildEmptyUI()
                        : _buildBookclubList(),
          ),
          // 떠 있는 버튼 (고정)
          Positioned(
            bottom: 24, // 하단 여백
            right: 24, // 우측 여백
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateBookclubPage()),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigation(
        selectedIndex: 1,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildBookclubList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _myBookclubs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final myBookclub = _myBookclubs[index];
        final bookclub = myBookclub['bookClub'];
        final formattedDate = DateFormat('yyyy년 MM월 dd일 HH:mm').format(DateTime.parse(myBookclub['meetingDate']));
        return BookclubCard(
          imageUrl: bookclub['imageUrl'] ?? '',
          bookTitle: bookclub['bookTitle'] ?? '제목 없음',
          participants: bookclub['participants'] ?? 0,
          meetingDate: formattedDate,
        );
      },
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchMyBookclubs,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '현재 참여 중인 북클럽이 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('새로운 북클럽 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookclubCard extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final int participants;
  final String meetingDate;

  const BookclubCard({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.participants,
    required this.meetingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('참여자: $participants명', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('모임 날짜: $meetingDate', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
