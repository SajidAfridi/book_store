import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/book.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isFavorite = true;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? favoriteStatus = prefs.getBool(widget.book.key);
    setState(() {
      isFavorite = favoriteStatus ?? false;
    });
  }

  Future<void> saveFavoriteStatus(bool favoriteStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedKeys = prefs.getStringList('bookmarkedBookKeys') ?? [];
    if (favoriteStatus) {
      bookmarkedKeys.add(widget.book.key);
    } else {
      bookmarkedKeys.remove(widget.book.key);
    }
    await prefs.setStringList('bookmarkedBookKeys', bookmarkedKeys);
  }

  void _toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
      saveFavoriteStatus(isFavorite);
    });
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.4,
                child: Image.network(
                  widget.book.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Author(s):',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.book.authors.join(", "),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Summary:',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.book.summary,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavoriteStatus,
        child: isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
      ),
    );
  }
}
