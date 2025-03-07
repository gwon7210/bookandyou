import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";
  static const String _tokenKey = 'jwt_token';

  // ✅ 공통 GET 요청 함수 (JWT 포함)
  static Future<http.Response> get(String endpoint) async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception("로그인이 필요합니다.");
    }

    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
    );
  }

  // ✅ 공통 POST 요청 함수 (JWT 포함)
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool includeAuth = true}) async {
    final String? token = includeAuth ? await getToken() : null;

    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
  }

  // JWT 토큰 저장 메서드
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // JWT 토큰 가져오기 메서드
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ✅ 공통 헤더 설정
  static Map<String, String> _headers(String? token) {
    final headers = {
      "Content-Type": "application/json",
    };

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }
}
