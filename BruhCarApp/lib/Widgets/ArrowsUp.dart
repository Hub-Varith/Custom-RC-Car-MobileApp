import 'package:BruhCarApp/Widgets/Services/BT.dart';
import 'package:flutter/material.dart';

class ArrowUp extends StatelessWidget {
  final BTServices model;
  ArrowUp({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.topCenter,
        child:
            Icon(Icons.arrow_drop_up_rounded, size: 200, color: Colors.white),
      ),
      onLongPress: () {
        model.moveForward();
      },
      onLongPressEnd: (LongPressEndDetails details) {
        model.stopBackMotor();
      },
    );
  }
}
