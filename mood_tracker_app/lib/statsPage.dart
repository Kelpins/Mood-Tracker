import 'package:flutter/material.dart';
import 'heatmap.dart';
import 'StatPage2.dart';
import 'moodEffect.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: Center(child: Text("Statistics")),
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.calendar_month),
                    ),
                    Tab(
                      icon: Icon(Icons.polyline),
                    ),
                    Tab(
                      icon: Icon(Icons.align_horizontal_left_rounded),
                    ),
                  ],
                )),
            body: TabBarView(
              children: <Widget>[
                heatmap(),
                StatPage2(),
                moodEffect(),
              ],
            )));
  }
}
