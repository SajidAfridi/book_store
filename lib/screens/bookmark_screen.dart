import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../classes/book.dart';
import 'book_details_screen.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Book> bookmarkedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchBookmarkedBooks();
  }

  Future<void> fetchBookmarkedBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedKeys = prefs.getStringList('bookmarkedBookKeys');
    print(bookmarkedKeys);
    if (bookmarkedKeys != null) {
      List<Book> books = [];

      for (String key in bookmarkedKeys) {
        Book book = await fetchBookDetails(key);
        books.add(book);
      }

      setState(() {
        bookmarkedBooks = books;
      });
    }
  }

  Future<Book> fetchBookDetails(String key) async {
    final url = 'https://openlibrary.org$key.json';
    final response = await http.get(Uri.parse(url));
    print('Key: $key');
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Extract the necessary details from the response
      String title = data['title'];
      List<String> authors = data['authors'] != null
          ? (data['authors'] as List).cast<Map<String, dynamic>>().map((author) => author['name'].toString()).toList()
          : [];
      String imageUrl = data['cover'] != null ? 'https://covers.openlibrary.org/b/id/${data['cover'][0]}.jpg' : '';
      String summary = data['description'] != null ? data['description']['value'] : '';

      return Book(
        key: key,
        title: title,
        authors: authors,
        imageUrl: imageUrl,
        summary: summary,
      );
    } else {
      throw Exception('Failed to fetch book details');
    }
  }
  void _removeBookmark(BuildContext context, Book book) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedKeys = prefs.getStringList('bookmarkedBookKeys');
    if (bookmarkedKeys != null) {
      bookmarkedKeys.remove(book.key);
      await prefs.setStringList('bookmarkedBookKeys', bookmarkedKeys);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark removed')),
    );
    fetchBookmarkedBooks(); // Refresh the bookmarked books list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedBooks.length,
        itemBuilder: (context, index) {
          final book = bookmarkedBooks[index];
          return ListTile(
            leading: Image.network(book.imageUrl),
            title: Text(book.title),
            subtitle: Text(book.authors.join(", ")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(book: book),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remove Bookmark'),
                    content: const Text('Are you sure you want to remove this bookmark?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Remove'),
                        onPressed: () {
                          Navigator.pop(context);
                          _removeBookmark(context, book);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}