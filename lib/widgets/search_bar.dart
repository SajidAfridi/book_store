import 'package:book_zone/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
           SizedBox(width: 8.0.w),
          Container(
            width: 300.w,
            height: 50.h,
            child: TextField(
              controller: _searchController,
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
                String searchTerm = _searchController.text;
                // Perform search based on the search term
                // Add your logic here
              },
            ),
          ),
        ],
      ),
    );
  }
}