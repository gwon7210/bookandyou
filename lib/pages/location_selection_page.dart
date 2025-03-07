import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import 'dart:convert';

class LocationSelectionPage extends StatefulWidget {
  final int age;
  final String introduction;
  final String idealPerson;

  const LocationSelectionPage({
    super.key,
    required this.age,
    required this.introduction,
    required this.idealPerson,
  });

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 권한이 거부되었습니다. 설정에서 변경해주세요.')),
      );
      return;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      await _sendProfileToServer(latitude, longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 정보를 가져오는 데 실패했습니다: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendProfileToServer(String latitude, String longitude) async {
    try {
      final response = await ApiService.post('/profile', {
        "age": widget.age,
        "introduction": widget.introduction,
        "idealPerson": widget.idealPerson,
        "latitude": latitude,
        "longitude": longitude,
      });

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/home'); // 위치 설정 완료 후 홈으로 이동
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${responseBody["message"]}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $e')),
      );
    }
  }

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
              '내 지역 설정',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              '설정한 후에도 지역을 변경하고 싶을 때 언제든지 변경할 수 있어요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.green) // 로딩 표시
                : ElevatedButton(
                    onPressed: _requestLocationPermission, // 위치 권한 요청 및 저장
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('내 지역 설정하기'),
                  ),
          ],
        ),
      ),
    );
  }
}
