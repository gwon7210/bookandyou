import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateBookclubPage extends StatefulWidget {
  const CreateBookclubPage({super.key});

  @override
  State<CreateBookclubPage> createState() => _CreateBookclubPageState();
}

class _CreateBookclubPageState extends State<CreateBookclubPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedAge;
  String? _selectedMaxMembers;
  String? _selectedCategory;

  final List<String> ageOptions = ["20", "30", "40", "50", "60"]; // "직접 입력" 삭제
  final List<String> maxMembersOptions = [
    "10명",
    "20명",
    "30명",
    "50명",
  ]; // "직접 입력" 삭제
  final List<String> categoryOptions = [
    "인문학",
    "철학",
    "자기계발",
    "소설",
    "시/에세이",
    "경제/경영",
    "과학/기술",
    "예술/문화",
  ];

  Future<void> _createBookclub() async {
    if (_nameController.text.isEmpty ||
        _bookTitleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedAge == null ||
        _selectedMaxMembers == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("모든 필드를 입력해주세요!")));
      return;
    }

    // 🔹 숫자로 변환
    int ageValue = int.parse(_selectedAge!);
    int maxMembersValue = int.parse(_selectedMaxMembers!.replaceAll("명", ""));

    final Map<String, dynamic> data = {
      "name": _nameController.text,
      "bookTitle": _bookTitleController.text,
      "description": _descriptionController.text,
      "age": ageValue,
      "maxMembers": maxMembersValue,
      "category": _selectedCategory,
    };

    try {
      final response = await ApiService.post('/book-clubs', data);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("북클럽이 성공적으로 생성되었습니다!")));
        Navigator.pop(context);
      } else {
        throw Exception('북클럽 생성에 실패했습니다.');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
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
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "어떤 독서모임을 만들까요?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, "북클럽 이름"),
            const SizedBox(height: 16),
            _buildTextField(_bookTitleController, "책 제목"),
            const SizedBox(height: 16),
            _buildTextField(_descriptionController, "북클럽 소개", maxLines: 4),
            const SizedBox(height: 24),

            _buildSectionTitle("카테고리"),
            _buildOptionButtons(categoryOptions, _selectedCategory, (value) {
              setState(() {
                _selectedCategory = value;
              });
            }),

            const SizedBox(height: 24),
            _buildSectionTitle("참가 연령"),
            _buildOptionButtons(ageOptions, _selectedAge, (value) {
              setState(() {
                _selectedAge = value;
              });
            }),

            const SizedBox(height: 24),
            _buildSectionTitle("최대 인원"),
            _buildOptionButtons(maxMembersOptions, _selectedMaxMembers, (
              value,
            ) {
              setState(() {
                _selectedMaxMembers = value;
              });
            }),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createBookclub,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "북클럽 만들기",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildOptionButtons(
    List<String> options,
    String? selectedValue,
    Function(String) onSelected,
  ) {
    return Wrap(
      spacing: 8,
      children:
          options.map((option) {
            final bool isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
              selectedColor: Colors.green[200],
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
    );
  }
}
