import 'package:flutter/material.dart';
import 'package:BruhCarApp/Widgets/Services/BT.dart';

class ArrowDown extends StatelessWidget {
  final BTServices model;
  ArrowDown({this.model});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.topCenter,
        child: Icon(
          Icons.arrow_drop_down_rounded,
          size: 200,
          color: Colors.white,
        ),
      ),
      onLongPress: () {
        model.moveBackwards();
      },
      onLongPressEnd: (LongPressEndDetails details) {
        model.stopBackMotor();
      },
    );
  }
}
