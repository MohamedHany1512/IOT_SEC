import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AboutPage extends StatelessWidget {
  static const String id = 'AboutPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('About'),backgroundColor: Colors.grey[400],
     
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
             Text(
              'App Name : IoT_SeC',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 5.h),
          Row(children: [ Text('App Logo :   ',style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.bold),),ClipOval(
           
            child: Image.asset('assets/splashScreen.jpg',height: 20.h,fit: BoxFit.cover,))],),
             SizedBox(height: 5.h),
             Text(
              'Description:',
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 3.h),
             Text(
              'This App is designed to allow users to remotely control various devices from their smartphones. Whether its turning on (Lights, Fan, Lcd) and monitoring the reading of gas sensor, this app provides a convenient solution for managing IoT (Internet of Things) devices from any where with an internet connection,',
              style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
