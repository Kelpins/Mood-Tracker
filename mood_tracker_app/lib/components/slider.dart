import 'package:flutter/material.dart';

// mood gradient selector class
class MySlider extends StatelessWidget {
  final onChanged;
  final double val;
  final double min;
  final double max;
  final IconData icon;

  const MySlider(
      {super.key,
      required this.val,
      required this.min,
      required this.max,
      required this.icon,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: val,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }
}
