import 'package:flutter/material.dart';

// mood gradient selector class
class MySlider extends StatelessWidget {
  final onChanged;
  final double val;
  final double min;
  final double max;
  final int step;

  const MySlider(
      {super.key,
      required this.val,
      required this.min,
      required this.max,
      required this.step,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: val,
      onChanged: onChanged(val),
      min: min,
      max: max,
      divisions: step,
    );
  }
}
