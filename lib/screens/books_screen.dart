import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../classes/book.dart';
import '../utils/app_colors.dart';
import 'book_details_screen.dart';

class BookListView extends StatefulWidget {
  const BookListView({Key? key}) : super(key: key);

  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    const url = 'https://openlibrary.org/subjects/fiction.json?limit=100';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['works'] is List) {
        setState(() {
          books = data['works']
              .map<Book>((item) {
            final String key = item['key'] ?? '';
            final String title = item['title'] ?? '';
            final List<String> authors = item['authors'] != null
                ? List<String>.from(item['authors'].map((author) => author['name']))
                : [];
            final String imageUrl = 'http://covers.openlibrary.org/b/olid/$key-M.jpg';
            const String summary = '';

            return Book(
              key: key,
              title: title,
              authors: authors,
              imageUrl: imageUrl,
              summary: summary,
            );
          }).toList();
          filteredBooks = List.from(books);
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to fetch books');
    }

    // Fetch summaries for each book
    for (final book in books) {
      await book.fetchSummary();
      setState(() {});
    }
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks = books
          .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, 'bookmark_screen');
          }, icon: const Icon(Icons.bookmark))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: searchBar(),
          ),
          Expanded(
            child: isLoading
                ? _buildLoadingScreen()
                : ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(book.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'By ${book.authors.join(", ")}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(book: book),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLoadingScreen() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 12,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 12,
                        width: 200,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Container searchBar(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 8.0.w),
          SizedBox(
            width: 300.w,
            height: 50.h,
            child: TextField(
              onChanged: filterBooks,
              decoration: const InputDecoration(
                hintText: 'Search for a Book, Library or Author',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Center(
            child: IconButton(
              icon: Icon(Icons.search, size: 50.sp,color: Colours.loginButtonColor,),
              onPressed: () {
                String searchTerm = 'Search for a Book, Library or Author';
                filterBooks;
              },
            ),
          ),
        ],
      ),
    );
  }
}