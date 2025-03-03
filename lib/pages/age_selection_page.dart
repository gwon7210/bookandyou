import 'package:flutter/material.dart';
import 'introduction_page.dart';

class AgeSelectionPage extends StatefulWidget {
  const AgeSelectionPage({super.key});

  @override
  _AgeSelectionPageState createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  int _selectedYear = 1990; // 기본값 설정

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '나이를 선택하세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: _selectedYear,
              items: List.generate(26, (index) => 1980 + index).map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text('$year년생'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value!;
                });
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroductionPage(age: _selectedYear),
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
