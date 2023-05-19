import 'package:book_zone/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text1,
    required this.text2,
    required this.icon,
  }) : super(key: key);

  final String text1;
  final String text2;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          icon,
          SizedBox(width: 20.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text1,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colours.themeColor,
                  ),
                ),
                Text(
                  text2,
                  style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Colours.loginButtonColor,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
