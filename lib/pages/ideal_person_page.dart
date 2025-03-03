import 'package:flutter/material.dart';
import 'location_selection_page.dart'; // 지역 설정 페이지 import

class IdealPersonPage extends StatefulWidget {
  final int age;
  final String introduction;

  const IdealPersonPage({super.key, required this.age, required this.introduction});

  @override
  _IdealPersonPageState createState() => _IdealPersonPageState();
}

class _IdealPersonPageState extends State<IdealPersonPage> {
  final TextEditingController _idealPersonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지(자기소개 페이지)로 이동
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '이런 사람을 만나고 싶어요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _idealPersonController,
              maxLength: 200,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '이상형을 입력하세요 (최대 200자)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 사용자가 입력한 이상형 정보를 가져오기
                String idealPersonText = _idealPersonController.text.trim();

                // 지역 설정 페이지로 이동하면서 기존 데이터도 함께 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSelectionPage(
                      age: widget.age,
                      introduction: widget.introduction,
                      idealPerson: idealPersonText,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
