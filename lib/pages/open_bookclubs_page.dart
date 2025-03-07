import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'home_page.dart';

class OpenBookClubsPage extends StatefulWidget {
  const OpenBookClubsPage({super.key});

  @override
  _OpenBookClubsPageState createState() => _OpenBookClubsPageState();
}

class _OpenBookClubsPageState extends State<OpenBookClubsPage> {
  List<dynamic> _openBookClubs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOpenBookClubs();
  }

  Future<void> _fetchOpenBookClubs() async {
    try {
      final response = await ApiService.get('/open-bookclubs'); // ✅ API 요청
      if (response.statusCode == 200) {
        setState(() {
          _openBookClubs = jsonDecode(response.body);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          '현재 참여 가능한 북클럽',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _openBookClubs.isEmpty
              ? const Center(child: Text('현재 참여 가능한 북클럽이 없습니다.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _openBookClubs.length,
                  itemBuilder: (context, index) {
                    final bookClub = _openBookClubs[index];
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
                              bookClub['roomTitle'] ?? '방 제목 없음',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              bookClub['bookTitle'] ?? '책 제목 없음',
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '방장: ${bookClub['nickname'] ?? '닉네임 없음'}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
