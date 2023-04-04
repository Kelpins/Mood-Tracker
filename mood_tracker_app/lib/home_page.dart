import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String time = DateFormat("jm").format(now);
    String month = DateFormat("MMMM").format(now);
    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEEE').format(now);

    String docDay = DateFormat('MM-dd-yyyy').format(now);

    //double slider_value = 20;

    final db = FirebaseFirestore.instance;

    void createUser() {
      final dailyDocData = {
        "Habit_1": true,
        "Habit_2": false,
        "Habit_3": false,
        "mood": 5,
      };

      final habitDocData = {
        "Description": "Thirty minute nap at least twice a week",
        "Icon": "Icon(Icons.bed)",
        "Name": "Taking Naps",
        "Timing": "weekly"
      };

      db
          .collection("Users")
          .doc("User_2")
          .collection("Daily")
          .doc("$docDay")
          .set(dailyDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      db
          .collection("Users")
          .doc("User_2")
          .collection("Habits")
          .doc("Habit_1")
          .set(habitDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home")),
        ),
        body: Column(children: [
          Center(
              child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
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
                  padding: const EdgeInsets.all(10.0),
                  width: 350.0,
                  height: 75.0,
                  margin: const EdgeInsets.all(10.0),
                  child: Center(
                    child: ElevatedButton(
                      child: const Text("Add User"),
                      onPressed: () {
                        createUser();
                      },
                    ),
                    /*child: Slider(
                          min: 0,
                          max: 100,
                          value: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          })*/

                    /*
                      child: Form(
                          child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "How are you doing?"),
                  ))*/
                  )))
        ]));
  }
}
