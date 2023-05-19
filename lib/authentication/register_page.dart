import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_number/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../utils/app_sizebox.dart';
import '../widgets/button_style.dart';
import '../widgets/input_decoration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? phoneNumberError;

  String professionValue = 'Student';
  String genderValue = 'Male';

  bool loginPressed = false;
  bool isRegistering = false;

  @override
  void dispose() {
    city.dispose();
    address.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colours.whiteBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
            ),
            Center(
              child: Image(
                image: const AssetImage("assets/images/logo_book_store.jpeg"),
                width: ScreenUtil().setWidth(180),
                height: ScreenUtil().setHeight(100),
              ),
            ),
            fixSizedBox40,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      controller: name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                      decoration: inputDecoration("Enter Your Name"),
                    ),
                  ),
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: DropdownButtonFormField<String>(
                      value: professionValue,
                      decoration: inputDecoration("Select Your Profession"),
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'Student',
                          child: Text('Student'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Teacher',
                          child: Text('Teacher'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Librarian',
                          child: Text('Librarian'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          professionValue = value!;
                        });
                      },
                    ),
                  ),
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      obscureText: false,
                      controller: city,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                      decoration: inputDecoration("Enter Your City Name"),
                    ),
                  ),
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: DropdownButtonFormField<String>(
                      value: genderValue,
                      decoration: inputDecoration("Select Your Gender"),
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'Male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Other',
                          child: Text('Other'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          genderValue = value!;
                        });
                      },
                    ),
                  ),
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      obscureText: false,
                      controller: address, // Add this line
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                      decoration: inputDecoration("Enter Your Address"),
                    ),
                  ),
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                      decoration: inputDecoration("Enter Your Phone Number "),
                      onChanged: (value) async {
                        if (value.isEmpty) {
                          setState(() {
                            phoneNumberError = 'Please enter a phone number';
                          });
                        } else {
                          final phoneNumber =
                              await PhoneNumberUtil().parse(value);
                          if (!await PhoneNumberUtil().validate(value,
                              regionCode: phoneNumber.regionCode)) {
                            setState(() {
                              phoneNumberError =
                                  'Please enter a valid phone number';
                            });
                          } else {
                            setState(() {
                              phoneNumberError = null;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                      decoration: inputDecoration("Enter Your Email"),
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
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
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
                  fixSizedBox10,
                  SizedBox(
                    width: 290.w,
                    height: loginPressed ? 70.h : 50.h,
                    child: TextFormField(
                      obscureText: true,
                      controller: confirmPassword,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                      decoration: inputDecoration("Confirm Password"),
                      validator: (value) {
                        if (value != password.text) {
                          return 'The Password Doesn\'t match';
                        }
                        return null;
                      },
                    ),
                  ),
                  fixSizedBox20,
                  ElevatedButton(
                    onPressed: isRegistering ? null : registerUser,
                    style: buttonStyle,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loginPressed = true;
        isRegistering = true;
      });
      // Register user with email and password
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((authResult) async {
        // Save user details to Firestore
        saveUserDetails(
          authResult.user!.uid,
          email.text,
          name.text,
          address.text, // Corrected order of parameters
          city.text, // Corrected order of parameters
          phoneNumberController.text,
          professionValue,
          genderValue,
        );
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('uid', authResult.user!.uid);

        // Navigate to the Questionnaire Screen
        Navigator.pushReplacementNamed(context, 'questionnaire_screen');
      }).catchError((error) {
        // Display registration error using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Error: ${error.toString()}"),
          ),
        );
      }).whenComplete(() {
        setState(() {
          isRegistering = false;
        });
      });
    }
  }
}
void saveUserDetails(
    String userId,
    String email,
    String name,
    String address, // Corrected order of parameters
    String city, // Corrected order of parameters
    String phoneNumber,
    String profession,
    String gender,
    ) {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  userRef.set({
    'email': email,
    'name': name,
    'city': city,
    'address': address,
    'phoneNumber': phoneNumber,
    'profession': profession,
    'gender': gender,
  }).then((value) {
    print('User details saved successfully!');
  }).catchError((error) {
    print('Failed to save user details: $error');
  });
}
