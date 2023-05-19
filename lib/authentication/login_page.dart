import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_sizebox.dart';
import '../utils/dividers.dart';
import '../widgets/button_style.dart';
import '../widgets/input_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool loginPressed = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colours.whiteBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 114.h,
            ),
            Center(
              child: Image(
                image: const AssetImage("assets/images/logo_book_store.jpeg"),
                width: 190.w,
                height: 120.h,
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 5.h, 30.w, 5.h),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: 290.w,
                        height: loginPressed ? 70.h : 50.h,
                        child: TextFormField(
                          controller: email,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                          decoration: inputDecoration("Email"),
                          validator: (value) {
                            final RegExp emailRegExp =
                                RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            } else if (!emailRegExp.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 13.h),
                    SizedBox(
                      width: 290.w,
                      height: loginPressed ? 70.h : 50.h,
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                        decoration: inputDecoration("Password"),
                        validator: (value) {
                          final RegExp passwordRegExp =
                              RegExp(r'^(?=.*[A-Za-z\d])[A-Za-z\d]{6,}$');
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (!passwordRegExp.hasMatch(value)) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    fixSizedBox20,
                    SizedBox(
                      width: 200.w,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loginPressed = !loginPressed;
                          });
                          signIn();
                        },
                        style: buttonStyle,
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                    fixSizedBox10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'register_screen');
                          },
                          // style: outlinedButtonStyle,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                color: Colours.themeColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 194.w,
                      child: divider4,
                    ),
                    fixSizedBox5,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    final formState = _formkey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text.toString(),
                password: password.text.toString());
        String uid = userCredential.user!.uid;

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool('isLoggedIn', true);
        sharedPreferences.setString('uid', uid);

        try {
          DocumentSnapshot? snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          if (snapshot.exists) {
            var data = snapshot.data() as Map<String, dynamic>;
            var profession = data['profession'];
            sharedPreferences.setString('profession', profession);
            print('profession: $profession');

          } else {
            print('Document not found!');
          }
        } catch (e) {
          print('Error retrieving document: $e');
        }

        Navigator.pushReplacementNamed(context, 'home_screen');
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Error: ${error.toString()}"),
          ),
        );
      }
    }
  }
}
