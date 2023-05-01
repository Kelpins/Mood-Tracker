import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class heatmap extends StatelessWidget {
  final String documentId;

  @override
  Widget build(BuildContext context) {
    // Create a heatmap widget using the Flutter calendar heatmap library
    return Container(
        margin: const EdgeInsets.all(20),
        child: HeatMap(
            // Properties for the heatmap widget
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
              // Provide the dataset for the heatmap, mapping date & time to values
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
              // Colorsets (themes)
              1: Colors.purple,
            },
            onClick: (value) {
              // onClick event
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value.toString())));
            }));
  }
}
