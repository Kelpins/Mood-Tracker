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
                margin: const EdgeInsets.all(10.0),
                color: Color.fromARGB(255, 140, 0, 255),
                width: 250.0,
                height: 250.0,
                child: Column(
                  children: [
                    Text("Today is Tuesday, March 7th"),
                    Text("Element 2"),
                  ],
                ))));
  }
}
