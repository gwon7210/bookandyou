import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _bookClubs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookClubs();
  }

  Future<void> _fetchBookClubs() async {
    final apiUrl = Uri.parse('http://10.0.2.2:3000/bookclubs'); // API 엔드포인트
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          _bookClubs = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '북앤유',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/bookclubs');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('현재 참여 가능한 북클럽 페이지'),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _bookClubs.length,
                      itemBuilder: (context, index) {
                        final bookClub = _bookClubs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookClub['nickname'] ?? '닉네임 없음',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  bookClub['bookTitle'] ?? '책 제목 없음',
                                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bookClub['introduction'] ?? '소개 없음',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {}, // 기능 미정
                                    child: const Text('더보기', style: TextStyle(color: Colors.blue)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
