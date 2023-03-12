import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class heatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // from https://pub.dev/packages/flutter_heatmap_calendar
    return Container(
        margin: const EdgeInsets.all(20),
        child: HeatMap(
            defaultColor: Colors.white,
            scrollable: true,
            colorMode: ColorMode.opacity,
            size: 40,
            fontSize: 20,
            showColorTip: false,
            showText: true,
            borderRadius: 10,
            margin: const EdgeInsets.all(5),
            datasets: {
              DateTime(2023, 3, 1): 1,
              DateTime(2023, 3, 2): 10,
              DateTime(2023, 3, 3): 15,
              DateTime(2023, 3, 4): 3,
              DateTime(2023, 3, 5): 6,
              DateTime(2023, 3, 6): 3,
              DateTime(2023, 3, 7): 7,
              DateTime(2023, 3, 8): 10,
              DateTime(2023, 3, 9): 13,
              DateTime(2023, 3, 10): 6,
            },
            colorsets: const {
              1: Colors.purple,
            },
            onClick: (value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value.toString())));
            }));
  }
}
