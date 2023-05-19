import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login_page.dart';
import 'home_screen.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool changedPosition = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    _sharedPrep();
    _changeposition();
    _navigate();
    super.initState();
  }
  _navigate()async{
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    if(isLoggedIn){
      Navigator.pushReplacementNamed(context, 'home_screen');
    }
    else{
      Navigator.pushReplacementNamed(context, 'login_screen');
    }
    isLoggedIn ? HomeScreen() : const LogInScreen();

  }
  _sharedPrep()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
  }
  _changeposition()async{
    await Future.delayed(const Duration(milliseconds: 1000),(){
      setState(() {
        changedPosition = !changedPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1.0,
              width: MediaQuery.of(context).size.width * 1.0,
            ),
          ),
          AnimatedPositioned(
            top: !changedPosition
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.2,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  height: 200.h,
                  width: 200.w,
                  child: Image(
                    image: const AssetImage('assets/images/splash_screen_logo.jpeg'),
                    height: MediaQuery.of(context).size.height*0.4,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}