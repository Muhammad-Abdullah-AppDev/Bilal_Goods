import 'package:bilal_goods/screens/login_screen.dart';
import 'package:bilal_goods/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      navigateToScreen();
    });
  }

  void navigateToScreen() {
    String email = GetStorage().read('email') ?? '';
    String password = GetStorage().read('password') ?? '';

    if (email.isNotEmpty && password.isNotEmpty) {
      // User is already logged in, navigate to MenuScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5e8cba),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/bilalGoods.png', fit: BoxFit.fill,),
          ],
        ),
      ),
    );
  }
}
