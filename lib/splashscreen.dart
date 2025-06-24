import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/Login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
 
  static String id = 'SplashScreen';

  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splashIconSize: 1000.sp,
      splash: Image.asset('assets/splashScreen.jpg', fit: BoxFit.fill,),
      nextScreen: LoginPage(),
    );
  }
}
