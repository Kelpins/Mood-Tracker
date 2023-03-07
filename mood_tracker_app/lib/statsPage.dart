import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Statistics")),
        ),
        body: Column(
          children: [
            Text("This is the Statistics Page!!!"),
            Text("This is where you view data"),
          ],
        ));
  }
}
