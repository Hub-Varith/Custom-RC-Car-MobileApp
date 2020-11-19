import 'package:flutter/material.dart';

class Rudder extends StatefulWidget {
  @override
  _RudderState createState() => _RudderState();
}

class _RudderState extends State<Rudder> {
  @override
  Widget build(BuildContext context) {
    double _sliderValue = 20;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.red[700],
        inactiveTrackColor: Colors.red[100],
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 4.0,
        thumbColor: Colors.redAccent,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        overlayColor: Colors.red.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      ),
      child: Slider(
        min: 1,
        max: 100,
        value: _sliderValue,
        onChanged: (newValue) {
          setState(
            () {
              _sliderValue = newValue;
            },
          );
        },
      ),
    );
  }
}
