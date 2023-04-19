import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String time = DateFormat("jm").format(now);
    String month = DateFormat("MMMM").format(now);
    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEEE').format(now);

    String today = DateFormat('MM-dd-yyyy').format(now);

    //double slider_value = 20;

    final db = FirebaseFirestore.instance;
    const email = "kellan@edgy.org";
    const habitName = "Taking Naps";

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

      final moodsDocData = {
        "$today": 4,
        //PAST MOOD DOC DATA -- TO READ
      };

      final userInfoDocData = {
        "email": email,
        "Name": "Kellan",
        "Password": "Firebase"
      };

      final preferencesDocData = {
        "color": "Colors.blue",
        "Language": "English"
      };

      //DAILY -- RUNS AT END OF EVERY DAY
      db
          .collection("Users")
          .doc("$email")
          .collection("Daily")
          .doc("$today")
          .set(dailyDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //HABITS -- RUNS ON NEW HABIT CREATED
      db
          .collection("Users")
          .doc("$email")
          .collection("Habits")
          .doc("$habitName")
          .set(habitDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //MOODS -- RUNS ON MOOD UPDATED
      db
          .collection("Users")
          .doc("$email")
          .collection("Moods")
          .doc("Mood")
          .set(moodsDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //USER DATA -- RUNS ON PROFILE CREATE, USER DATA UPDATED
      db
          .collection("Users")
          .doc("$email")
          .collection("User_Info")
          .doc("User")
          .set(userInfoDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //USER PREFERENCES -- RUNS ON PROFILE CREATE, PREFERENCES UPDATED
      db
          .collection("Users")
          .doc("$email")
          .collection("User_Info")
          .doc("Preferences")
          .set(preferencesDocData)
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
                      child: const Text("Log Out"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
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
                  ))),
          Center(child: Container(child: Text('signed in as ' + user.email!))),
        ]));
  }
}
