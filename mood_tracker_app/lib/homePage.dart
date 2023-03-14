import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String time = DateFormat("jm").format(now);
    String month = DateFormat("MMMM").format(now);
    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Home")),
        ),
        body: Column(children: [
          Center(
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 57, 150, 227),
                      Color.fromARGB(255, 165, 72, 182)
                    ]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  width: 350.0,
                  height: 75.0,
                  child: Center(
                    child: Text(
                      "It is $time on $weekday, $month $day!",
                      textScaleFactor: 1.25,
                    ),
                  ))),
          Center(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: 350.0,
                  height: 75.0,
                  margin: const EdgeInsets.all(10.0),
                  child: Center(
                      child: Form(
                          child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "How are you doing?"),
                  )))))
        ]));
  }
}
