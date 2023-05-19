import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_sizebox.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fixSizedBox5,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  'Book-Zone',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                      color: Colours.loginButtonColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 40.sp),
                ),
              ),
              fixSizedBox5,
              const SearchBar(),
              Divider(
                height: 2.0.h,
              ),
              _container(context, const AssetImage('assets/images/icon1.png'),
                  'My Account', 'Manage Your Account', () {
                Navigator.pushNamed(context, 'profile_screen');
              }),
              Column(
                children: [
                  _container(
                      context,
                      const AssetImage('assets/images/img_2.png'),
                      'Books',
                      'View your recommended Books\n'
                          'Search Books\'save your favorite \n'
                          'books', () {
                        Navigator.pushNamed(context, 'book_screen');
                  }),
                  _container(
                      context,
                      const AssetImage('assets/images/icon3.png'),
                      'Monthly Subscription',
                      'get you monthly subscription for\n'
                          ' unlimited borrowing access', () {
                    Navigator.pushNamed(context, 'subscription_screen');
                  }),
                  _container(
                      context,
                      const AssetImage('assets/images/icon4.png'),
                      'Nearest Libraries',
                      'Find a library branch that is'
                          ' convenient\n for you', () {
                    Navigator.pushNamed(context, 'map_screen');
                  }),
                  _container(
                      context,
                      const AssetImage('assets/images/icon5.png'),
                      'Book a seat and meet \nyour favorite author',
                      'book your seat for a reading \nsession or'
                          'for the latest author \nmeetings in libraries.', () {
                    Navigator.pushNamed(context, 'event_screen');
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _container(BuildContext context, AssetImage image, String text1,
      String text2, VoidCallback callbackAction) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.16,
      color: Colors.white54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: image,
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          SizedBox(width: 10.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style:
                TextStyle(color: Colours.loginButtonColor, fontSize: 20.sp,fontWeight: FontWeight.w700),
              ),
              fixSizedBox5,
              InkWell(
                onTap: callbackAction,
                child: Text(
                  text2,
                  style: TextStyle(
                    color: Colors.lightBlue[500],
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


