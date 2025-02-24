// models/book_club.dart
class BookClub {
  int? id;
  String bookTitle;
  String description;

  BookClub({
    this.id,
    required this.bookTitle,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookTitle': bookTitle,
      'description': description,
    };
  }

  factory BookClub.fromMap(Map<String, dynamic> map) {
    return BookClub(
      id: map['id'],
      bookTitle: map['bookTitle'],
      description: map['description'],
    );
  }
}
