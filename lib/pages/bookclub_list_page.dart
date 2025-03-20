import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookandyou/services/api_service.dart';

class BookclubListPage extends StatefulWidget {
  const BookclubListPage({super.key});

  @override
  State<BookclubListPage> createState() => _BookclubListPageState();
}

class _BookclubListPageState extends State<BookclubListPage> {
  List<dynamic> _bookclubs = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  String? _selectedCategory;

  final List<Map<String, dynamic>> bookCategories = [
    {"name": "전체", "icon": Icons.menu_book, "color": Colors.grey},
    {"name": "인문학", "icon": Icons.psychology, "color": const Color(0xFF5C6BC0)},
    {"name": "철학", "icon": Icons.lightbulb, "color": const Color(0xFF26A69A)},
    {
      "name": "자기계발",
      "icon": Icons.trending_up,
      "color": const Color(0xFF66BB6A),
    },
    {
      "name": "소설",
      "icon": Icons.auto_stories,
      "color": const Color(0xFFEC407A),
    },
    {
      "name": "시/에세이",
      "icon": Icons.edit_note,
      "color": const Color(0xFF7E57C2),
    },
    {
      "name": "경제/경영",
      "icon": Icons.business_center,
      "color": const Color(0xFF42A5F5),
    },
    {"name": "과학/기술", "icon": Icons.science, "color": const Color(0xFFEF5350)},
    {"name": "예술/문화", "icon": Icons.palette, "color": const Color(0xFFFFB300)},
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBookclubs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookclubs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.get('/book-clubs');

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

  List<dynamic> _getFilteredBookclubs() {
    return _bookclubs.where((bookclub) {
      // 검색어 필터링
      final nameMatches = bookclub['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final bookTitleMatches = bookclub['bookTitle']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      // 카테고리 필터링
      final categoryMatches =
          _selectedCategory == null ||
          _selectedCategory == "전체" ||
          bookclub['category'] == _selectedCategory;

      return (nameMatches || bookTitleMatches) && categoryMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookclubs = _getFilteredBookclubs();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '북클럽 목록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 검색 필드
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '북클럽 이름 또는 책 제목으로 검색',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // 카테고리 필터 (가로 스크롤)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bookCategories.length,
                itemBuilder: (context, index) {
                  final category = bookCategories[index];
                  final isSelected = _selectedCategory == category['name'];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory =
                              isSelected ? null : category['name'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? category['color'] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category['icon'],
                              size: 18,
                              color:
                                  isSelected ? Colors.white : category['color'],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category['name'],
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 북클럽 리스트
            Expanded(child: _buildBookclubList(filteredBookclubs)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookclubList(List<dynamic> bookclubs) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      return Center(
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
              onPressed: _fetchBookclubs,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    } else if (bookclubs.isEmpty) {
      return const Center(
        child: Text(
          '조건에 맞는 북클럽이 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bookclubs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final bookclub = bookclubs[index];
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
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.grey,
                          ),
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
