import 'package:BruhCarApp/Widgets/ArrowsDown.dart';
import 'package:BruhCarApp/Widgets/Services/BT.dart';
import 'package:BruhCarApp/Widgets/Services/ScannedDevices.dart';
import 'package:flutter/material.dart';
import 'Widgets/ArrowsUp.dart';

class HomeScreen extends StatefulWidget {
  final BTServices model;
  HomeScreen({this.model});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.initializeBle();
  }

  double _value = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C4C),
      body: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ArrowUp(model: widget.model),
                  ArrowDown(model: widget.model),
                ],
              ),
            ),
            // Rudder(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Color(0xFF373737),
                    inactiveTrackColor: Color(0xFF373737),
                    trackShape: RectangularSliderTrackShape(),
                    trackHeight: 30,
                    thumbColor: Color(0xFFFF7682),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 30.0),
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  ),
                  child: Container(
                    width: 400,
                    child: Slider(
                        value: _value,
                        min: 1,
                        max: 100,
                        onChanged: (newValue) {
                          if (newValue < 50) {
                            widget.model.turnLeft();
                          }

                          if (newValue > 50) {
                            widget.model.turnRight();
                          }
                          setState(() {
                            _value = newValue;
                          });
                        },
                        onChangeEnd: (newValue) {
                          widget.model.stopFrontMotor();
                          setState(() {
                            _value = 50;
                          });
                        }),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: FlatButton(
                    onPressed: () {
                      widget.model.init();
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StreamBuilder<List<ScannedDevices>>(
                              stream: widget.model.visibleDevices,
                              builder: (ctx, snapshot) {
                                if (!snapshot.hasData) {
                                  return AlertDialog(
                                    title: Text("Searching"),
                                    actions: [
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: Navigator.of(context).pop,
                                      ),
                                    ],
                                  );
                                }
                                return AlertDialog(
                                  title: Text(
                                      "Found Device ${widget.model.peripheral.name}"),
                                  actions: [
                                    FlatButton(
                                        child: Text("Connect to peripherals"),
                                        onPressed: () {
                                          widget.model
                                              .connectToPeripherals()
                                              .then((value) =>
                                                  Navigator.of(context).pop());
                                          // return StreamBuilder<Object>(
                                          //     stream:
                                          //         widget.model.connectedDevices,
                                          //     builder: (context, snapshot) {
                                          //       if (!snapshot.hasData) {
                                          //         AlertDialog(
                                          //           title: Text(
                                          //               "Press to connect"),
                                          //           actions: [
                                          //             FlatButton(
                                          //               child: Text("connect"),
                                          //               onPressed: () {
                                          //                 widget.model
                                          //                     .connectToPeripherals();
                                          //               },
                                          //             )
                                          //           ],
                                          //           // actions: [
                                          //           //   FlatButton(
                                          //           //       child: Text(
                                          //           //           "Connect to the car"),
                                          //           //       onPressed: () {
                                          //           //         widget.model
                                          //           //             .connectToPeripherals();
                                          //           //         print(
                                          //           //             "Connecting to peripherals");
                                          //           //       }),
                                          //           // ],
                                          //         );
                                          //         return AlertDialog(
                                          //           title: Text(
                                          //               "Device Connected"),
                                          //           actions: [
                                          //             FlatButton(
                                          //                 child: Text("Done"),
                                          //                 onPressed: () {
                                          //                   Navigator.of(
                                          //                           context)
                                          //                       .pop();
                                          //                 }),
                                          //           ],
                                          //         );
                                          //       }
                                          //       return AlertDialog(
                                          //         title: Text("Connected"),
                                          //         actions: [],
                                          //       );
                                          //     });
                                        }),
                                  ],
                                );
                                //   return StreamBuilder<Object>(
                                //       stream: widget.model.connectedDevices,
                                //       builder: (context, snapshot) {
                                //         if (!snapshot.hasData) {
                                //           AlertDialog(
                                //             title: Text("Found Device"),
                                //             actions: [
                                //               FlatButton(
                                //                   child:
                                //                       Text("Connect to the car"),
                                //                   onPressed: () {
                                //                     widget.model
                                //                         .connectToPeripherals();
                                //                     print(
                                //                         "Connecting to peripherals");
                                //                   }),
                                //             ],
                                //           );
                                //           print("Connected");
                                //           return AlertDialog(
                                //             title: Text("Device Connected"),
                                //             actions: [
                                //               FlatButton(
                                //                   child: Text("Done"),
                                //                   onPressed: () {
                                //                     Navigator.of(context).pop();
                                //                   }),
                                //             ],
                                //           );
                                //         }
                                //         return AlertDialog(
                                //           title: Text("Connected"),
                                //           actions: [],
                                //         );
                                //       });
                              },
                            );
                          });
                    },
                    child: Text("Scan for RC cars"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
