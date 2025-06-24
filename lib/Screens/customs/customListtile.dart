import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Customlisttile extends StatelessWidget {
   Customlisttile({super.key,required this.icon,required this.text, this.function});
IconData icon;
String text;
VoidCallback? function;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
      leading: Icon(icon),
      title: Text(text,style: TextStyle(fontSize: 18.sp),),
      
      onTap:function ,
      contentPadding: const EdgeInsets.all(10),
      titleTextStyle:  TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.black),
      ),
    );
  }
}