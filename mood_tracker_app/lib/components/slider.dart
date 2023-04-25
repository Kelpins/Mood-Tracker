import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
  final onChanged;
  final double val;
  final double min;
  final double max;

  const MySlider(
      {super.key,
      required this.val,
      required this.min,
      required this.max,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: val,
      onChanged: onChanged(val),
      min: min,
      max: max,
    );
  }
}
