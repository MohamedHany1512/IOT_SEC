import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/gasread.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class gas_sensor extends StatefulWidget {
  const gas_sensor({Key? key}) : super(key: key);

  @override
  State<gas_sensor> createState() => _gas_sensorState();
}

class _gas_sensorState extends State<gas_sensor> {
  late bool isSwitched;
   Color? colorContainer;
  late DatabaseReference referenceDatabase;

  @override
  void initState() {
    super.initState();
    isSwitched = false;
    colorContainer =   Colors.grey[200];
  
  }

 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap:(){
          Navigator.pushNamed(context, Gasread.id);
        },
        child: SingleChildScrollView(
          child:  Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              
              color: colorContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Icon(
                  Icons.sensors,
                  size: 30.sp,
                  color: Colors.black
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  'Enter to know the Gas Sensor value',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

