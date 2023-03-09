import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.calendar_month)),
                Tab(icon: Icon(Icons.polyline)),
                Tab(icon: Icon(Icons.align_horizontal_left_rounded)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.calendar_month),
              Icon(Icons.polyline),
              Icon(Icons.align_horizontal_left_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
