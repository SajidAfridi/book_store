import 'package:book_zone/screens/bookmark_screen.dart';
import 'package:book_zone/screens/books_screen.dart';
import 'package:book_zone/screens/event_screen.dart';
import 'package:book_zone/screens/home_screen.dart';
import 'package:book_zone/screens/loading_screen.dart';
import 'package:book_zone/screens/map_screen.dart';
import 'package:book_zone/screens/profile_screen.dart';
import 'package:book_zone/screens/questionare_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'authentication/login_page.dart';
import 'authentication/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Book Store',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          routes: {
            'register_screen': (_) => const RegisterScreen(),
            'loading_screen': (_) => const LoadingPage(),
            'questionnaire_screen': (_) => const QuestionnaireScreen(),
            'home_screen': (_) => HomeScreen(),
            'login_screen': (_) => const LogInScreen(),
            'profile_screen': (_) => const ProfileScreen(),
            'map_screen': (_) => MapScreen(),
            'bookmark_screen': (_) => const BookmarkPage(),
            'event_screen': (_) => const EventScreen(),
            'book_screen': (_) => const BookListView(),
          },
          home: const EventScreen(),
        );
      },
    );
  }
}
