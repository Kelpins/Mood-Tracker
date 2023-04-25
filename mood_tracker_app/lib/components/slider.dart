import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
  final Function()? onChangeEnd;
  final int min;
  final int max;
  final IconData icon;

  const MySlider(
      {super.key,
      required this.min,
      required this.max,
      required this.icon,
      required this.onChangeEnd});

  @override
  Widget build(BuildContext context) {
    return Slider(
      onChangeEnd: onTap,
      child: Container(child: Icon(icon)),
    );
  }
}
