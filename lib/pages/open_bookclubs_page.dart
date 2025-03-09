import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenBookclubsPage extends StatefulWidget {
  const OpenBookclubsPage({super.key});

  @override
  State<OpenBookclubsPage> createState() => _OpenBookclubsPageState();
}

class _OpenBookclubsPageState extends State<OpenBookclubsPage> {
  Position? _currentPosition;
  String _currentAddress = "위치 확인 중...";
  int _selectedIndex = 0;  // 홈 탭이 선택된 상태로 시작
  
  // 북클럽 데이터 상태 추가
  List<dynamic> _bookclubs = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  final List<Map<String, dynamic>> bookCategories = [
    {
      "name": "인문학",
      "icon": Icons.psychology,  // 두뇌/심리 아이콘
      "color": const Color(0xFF5C6BC0),  // 인디고 계열
    },
    {
      "name": "철학",
      "icon": Icons.lightbulb,  // 전구 아이콘
      "color": const Color(0xFF26A69A),  // 청록색 계열
    },
    {
      "name": "자기계발",
      "icon": Icons.trending_up,  // 상승 그래프 아이콘
      "color": const Color(0xFF66BB6A),  // 초록색 계열
    },
    {
      "name": "소설",
      "icon": Icons.auto_stories,  // 책 아이콘
      "color": const Color(0xFFEC407A),  // 분홍색 계열
    },
    {
      "name": "시/에세이",
      "icon": Icons.edit_note,  // 펜 아이콘
      "color": const Color(0xFF7E57C2),  // 보라색 계열
    },
    {
      "name": "경제/경영",
      "icon": Icons.business_center,  // 비즈니스 아이콘
      "color": const Color(0xFF42A5F5),  // 파란색 계열
    },
    {
      "name": "과학/기술",
      "icon": Icons.science,  // 과학 아이콘
      "color": const Color(0xFFEF5350),  // 빨간색 계열
    },
    {
      "name": "예술/문화",
      "icon": Icons.palette,  // 팔레트 아이콘
      "color": const Color(0xFFFFB300),  // 주황색 계열
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchBookclubs(); // API 호출 메서드 추가
  }

  // 북클럽 데이터를 가져오는, API 호출 메서드
  Future<void> _fetchBookclubs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/book-clubs'));
      
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          _bookclubs = decodedData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = '서버에서 데이터를 가져오는데 실패했습니다: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '데이터를 가져오는데 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _currentAddress = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      print("위치 정보를 가져오는데 실패했습니다: $e");
    }
  }

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {  // 홈 또는 북클럽 탭
      setState(() {
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),  // 배경색 변경
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              // 위치 선택 페이지로 이동
            },
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black87, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentAddress,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black54, size: 20),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // 책 카테고리 그리드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,  // 카테고리 버튼의 세로 길이 조정
                    ),
                    itemCount: bookCategories.length,
                    itemBuilder: (context, index) {
                      return CategoryButton(
                        icon: bookCategories[index]["icon"],
                        name: bookCategories[index]["name"]!,
                        color: bookCategories[index]["color"],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // 최근 만들어진 북클럽 리스트 (API 연동 부분)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '최근 만들어진 북클럽',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBookclubList(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: '북클럽'),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '알림'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
  
  // 북클럽 리스트를 빌드하는 위젯
  Widget _buildBookclubList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchBookclubs,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    } else if (_bookclubs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            '현재 참여 가능한 북클럽이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _bookclubs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final bookclub = _bookclubs[index];
          return BookclubCard(
            name: bookclub['name'] ?? '이름 없음',
            bookTitle: bookclub['bookTitle'] ?? '제목 없음',
            category: bookclub['category'] ?? '기타',
            participants: bookclub['participants'] ?? 0,
            imageUrl: bookclub['imageUrl'] ?? 'https://picsum.photos/200/300',
          );
        },
      );
    }
  }
}

class CategoryButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.name,
    required this.color,
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BookclubCard 클래스를 API 데이터를 사용하도록 수정
class BookclubCard extends StatelessWidget {
  final String name;
  final String bookTitle;
  final String category;
  final int participants;
  final String imageUrl;

  const BookclubCard({
    super.key,
    required this.name,
    required this.bookTitle,
    required this.category,
    required this.participants,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 북클럽 이미지
                Container(
                  width: 90,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 북클럽 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bookTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '$participants명 참여중',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}