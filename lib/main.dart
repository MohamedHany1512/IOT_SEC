import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/Login.dart';
import 'package:graduationproject/Screens/aboutPage.dart';
import 'package:graduationproject/Screens/devices.dart';
import 'package:graduationproject/Screens/gasread.dart';
import 'package:graduationproject/firebase_options.dart';
import 'package:graduationproject/splashscreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  runApp(
    
     const Starting());
}

class Starting extends StatelessWidget {
  const Starting({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder:(p0,p1,p2){ return MaterialApp(
        initialRoute: SplashScreen.id,
      
        debugShowCheckedModeBanner: false,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          LoginPage.id: (context) => LoginPage(),
          DevicesScreen.id: (context) => DevicesScreen(),
          Gasread.id: (context) => const Gasread(),
          AboutPage.id:(context)=>AboutPage(),
        },
      );
  });
  }
}
