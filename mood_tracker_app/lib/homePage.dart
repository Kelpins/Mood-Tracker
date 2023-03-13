import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Home")),
        ),
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.purple]),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(10.0),
                width: 250.0,
                height: 100.0,
                child: Column(
                  children: [
                    Text("Today is Tuesday, March 7th"),
                    Text("Element 2"),
                  ],
                ))));
  }
}
