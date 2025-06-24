  import 'package:firebase_database/firebase_database.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:responsive_sizer/responsive_sizer.dart';

  class CustomCard extends StatefulWidget {
    final String image;
    final String deviceName;

    CustomCard({required this.deviceName, required this.image});

    @override
    State<CustomCard> createState() => _CustomCardState();
  }

  class _CustomCardState extends State<CustomCard> {
    bool isSwitched = false;
    Color? colorContainer = Colors.grey[200];
    Color primarycolor = Colors.black;
    final DatabaseReference referenceDatabase = FirebaseDatabase.instance.ref();

    bool dialogShown=false;

    @override
    
    void initState() {
      super.initState();
      // Fetch gas sensor value from the database
      referenceDatabase.child('ESP/gas_sensor').onValue.listen((event) {
        dynamic value = event.snapshot.value;
        if (value != null) {
          setState(() {
            gasSensorValue = int.tryParse(value.toString());
            if (gasSensorValue != null && gasSensorValue! >= 80) {
          
  isSwitched=false;
              colorContainer = Colors.grey[200];
              primarycolor = Colors.black;
              referenceDatabase
                  .child('test')
                  .child(widget.deviceName)
                  .set(isSwitched)
                  .asStream();
                
                  
            }
          });
        }
      });
    }

    
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: colorContainer,
          ),
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                widget.image,
                height: 7.h,
                width: 40.w,
                color: primarycolor,
              ),
              SizedBox(
                height: 5.h
                ,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        widget.deviceName,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: primarycolor,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      value: isSwitched,
                      onChanged: (value) {
                        if (gasSensorValue! < 80) {
                          setState(() {
                            isSwitched = value;
                            if (isSwitched) {
                              colorContainer = Colors.black;
                              primarycolor = Colors.white;
                            } else {
                              colorContainer = Colors.grey[200];
                              primarycolor = Colors.black;
                            }
                            referenceDatabase
                                .child('test')
                                .child(widget.deviceName)
                                .set(isSwitched)
                                .asStream();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
    int? gasSensorValue;