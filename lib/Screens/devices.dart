import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/Login.dart';
import 'package:graduationproject/Screens/aboutPage.dart';
import 'package:graduationproject/Screens/customs/CustomCards.dart';
import 'package:graduationproject/Screens/customs/customListtile.dart';
import 'package:graduationproject/Screens/customs/gas_sensor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DevicesScreen extends StatefulWidget {
  DevicesScreen({this.username, this.updateUi});
  VoidCallback? updateUi;
  static String id = 'DevicesScreen';
  String? username;

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  DatabaseReference? referenceDatabase;
  List<Widget> widgetsToDisplay = [];
  int? gasSensorValue;
  bool check =true;
 @override
void initState() {
  super.initState();
  referenceDatabase = FirebaseDatabase.instance.ref("ESP/gas_sensor");
  Stream<DatabaseEvent> stream = referenceDatabase!.onValue;

  stream.listen((DatabaseEvent event) {
    // Check if the snapshot value is not null and is a valid number
    final value = event.snapshot.value;
    if (value != null && value.toString().isNotEmpty) {
      try {
        setState(() {
          gasSensorValue = int.parse(value.toString());
        });

        if (gasSensorValue != null && gasSensorValue! >= 80) {
          if (check == true) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              title: 'Gas Alert !!',
              desc: 'Gas leaking',
              btnOkText: 'OK',
              btnOkOnPress: () {},
            ).show();
            check = false;
          }
        } else {
          check = true;
        }
      } catch (e) {
        // Handle the error gracefully
        print('Error parsing gas sensor value: $e');
      }
    } else {
      // Handle null or invalid value
      print('Gas sensor value is null or empty');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          const Padding(padding: EdgeInsets.only(top: 25)),
          Customlisttile(
              icon: Icons.device_hub,
              text: 'Number of Devices         ${widgetsToDisplay.length}'),
          Customlisttile(
            icon: Icons.info,
            text: 'About',
            function: () {
              Navigator.pushNamed(context, AboutPage.id);
            },
          ),
          Customlisttile(
            icon: Icons.logout_outlined,
            text: 'Log Out',
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (route) => false);
            },
          ),
        ],
      )),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Welcome Home,',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18.sp,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Hello, ${widget.username}',
            style:  TextStyle(
                color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text('Smart Devices',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold)),
        ),
        StreamBuilder(
          stream: databaseReference.child('users/${widget.username}/devices').onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              // Get the value from the snapshot
              Map<dynamic, dynamic>? devicesMap = snapshot.data!.snapshot.value;

              // Determine the state of each device
              bool lcdState = devicesMap?['lcd'] ?? false;
              bool ledState = devicesMap?['led'] ?? false;
              bool fanState = devicesMap?['fan'] ?? false;
              bool gasState = devicesMap?['gas_sensor'] ?? false;

              // List of widgets to display based on device state
              widgetsToDisplay.clear();

              // Add widgets to the list based on device state
              if (lcdState) {
                widgetsToDisplay.add(CustomCard(
                  deviceName: 'lcd',
                  image: 'assets/icons/smart-tv.png',
                ));
              }
              if (ledState) {
                widgetsToDisplay.add(CustomCard(
                  deviceName: 'led',
                  image: 'assets/icons/light-bulb.png',
                ));
              }
              if (fanState) {
                widgetsToDisplay.add(CustomCard(
                  deviceName: 'fan',
                  image: 'assets/icons/fan.png',
                ));
              }
              if (gasState) widgetsToDisplay.add(const gas_sensor());

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    widgetsToDisplay;
                  });
                });
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(15),
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 225,
                  childAspectRatio: 1.3,
                  crossAxisCount: 2,
                ),
                itemCount: widgetsToDisplay.length,
                itemBuilder: (context, index) {
                  return widgetsToDisplay[index];
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('No Devices '),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ]),
    );
  }
}
