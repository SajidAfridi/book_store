import 'package:http/http.dart' as http;
import 'dart:convert';

class Book {
  final String key;
  final String title;
  final List<String> authors;
  final String imageUrl;
  String summary;
  bool isFavorite;

  Book({
    required this.key,
    required this.title,
    required this.authors,
    required this.imageUrl,
    required this.summary,
    this.isFavorite = false,
  });

  Future<void> fetchSummary() async {
    final url = 'https://openlibrary.org$key.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String? summary = data['description'] != null ? data['description']['value'] : null;
      if (summary != null) {
        this.summary = summary;
      }
    } else {
      throw Exception('Failed to fetch book summary');
    }
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'],
      title: json['title'],
      authors: List<String>.from(json['authors'].map((author) => author['name'])),
      imageUrl: json['cover']['large'],
      summary: json['summary'],
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'authors': authors.map((author) => {'name': author}).toList(),
      'cover': {'large': imageUrl},
      'summary': summary,
      'isFavorite': isFavorite,
    };
  }
}



