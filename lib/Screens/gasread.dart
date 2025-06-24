import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

class Gasread extends StatefulWidget {
  const Gasread({super.key});
  static String id = 'Gasread';

  @override
  State<Gasread> createState() => _GasreadState();
}

class _GasreadState extends State<Gasread> {
  late DatabaseReference referenceDatabase;
  bool check = true;
  @override
  void initState() {
    super.initState();
    referenceDatabase = FirebaseDatabase.instance.ref("ESP/gas_sensor");
    fetchGasSensorValue();
  }

  fetchGasSensorValue() async {
    try {
      Stream<DatabaseEvent> stream = referenceDatabase.onValue;

      stream.listen((DatabaseEvent event) {
        setState(() {
          gasSensorValue = event.snapshot.value.toString();
        });
      });
      if (int.parse(gasSensorValue!) >= 80) {
        if (check = true) {
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
      print('Error fetching gas sensor value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SfRadialGauge(
          title: GaugeTitle(
              text: 'Gas Sensor Reading',
              textStyle: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          enableLoadingAnimation: true,
          animationDuration: 4500,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 110,
              majorTickStyle:
                  const MajorTickStyle(color: Colors.red, thickness: 4),
              axisLabelStyle: const GaugeTextStyle(color: Colors.white),
              pointers: <GaugePointer>[
                NeedlePointer(
                  needleColor: Colors.red,
                  value: double.parse(gasSensorValue!),
                  enableAnimation: true,
                )
              ],
              ranges: [
                GaugeRange(
                  startValue: 0,
                  endValue: 30,
                  color: Colors.green,
                ),
                GaugeRange(
                  startValue: 30,
                  endValue: 80,
                  color: Colors.orange,
                ),
                GaugeRange(
                  startValue: 80,
                  endValue: 110,
                  color: Colors.red,
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  widget: Text(
                    gasSensorValue!,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  positionFactor: 0.5,
                  angle: 90,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

String? gasSensorValue = '0';
