import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'signin.dart';
import 'components/button.dart';
import 'components/slider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

import 'package:group_button/group_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!;
  double localSliderVal = 3;
  String username = "";

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String time = DateFormat("jm").format(now);
    String month = DateFormat("MMMM").format(now);
    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEEE').format(now);

    String today = DateFormat('MM-dd-yyyy').format(now);

    final db = FirebaseFirestore.instance;
    final email = user.email;
    const habitName = "Taking Naps";

    final _controller = GroupButtonController();

    void logOut() {
      FirebaseAuth.instance.signOut();
      //Navigator.pop(context);
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: MyStatefulWidget(), withNavBar: false);
    }

    CollectionReference moods = FirebaseFirestore.instance.collection('Users');

    /*final docRef = moods.doc(email).collection("Moods").doc("Mood");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Text(data.toString());
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return Text("YA DONE BORKED IT");*/

    return FutureBuilder<DocumentSnapshot>(
        future: moods.doc(email).collection("Moods").doc("Mood").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //Error Handling conditions
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          //Data is output to the user
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> moodsDocData =
                snapshot.data!.data() as Map<String, dynamic>;
            username = moodsDocData["username"];

            return Scaffold(
                appBar: AppBar(
                  title: Text("Hello, " + username),
                  backgroundColor: Color.fromARGB(255, 255, 184, 189),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.logout),
                        tooltip: "log out",
                        onPressed: () {
                          logOut();
                        }),
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 255, 240, 240),
                body: Column(children: [
                  /*Padding(
                    padding: EdgeInsets.all(24.0),
                  ),*/
                  // Time/Date Box
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
                          width: 375.0,
                          height: 75.0,
                          child: Center(
                            child: Text(
                              "Hello! It is $weekday, $month $day.\nHow are you doing today?",
                              textScaleFactor: 1.25,
                            ),
                          ))),
                  // Rainbow Gradient Slider
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 234, 131, 121),
                              Color.fromARGB(255, 240, 175, 130),
                              Color.fromARGB(255, 236, 208, 153),
                              Color.fromARGB(255, 187, 197, 152),
                              Color.fromARGB(255, 154, 185, 136),
                            ]),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          width: 350.0,
                          height: 50.0,
                          margin: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.mood_bad,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackShape: RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    activeTrackColor: Colors.grey[500],
                                    inactiveTrackColor: Colors.grey[300],
                                    thumbColor: Colors.grey[800],
                                  ),
                                  child: Slider(
                                      value: localSliderVal,
                                      min: 0,
                                      max: 6,
                                      onChanged: (val) {
                                        setState(() {
                                          localSliderVal = val;
                                        });
                                        moodsDocData["$today"] = localSliderVal;

                                        db
                                            .collection("Users")
                                            .doc("$email")
                                            .collection("Moods")
                                            .doc("Mood")
                                            .set(moodsDocData)
                                            .onError(
                                                // ignore: avoid_print
                                                (e, _) => print(
                                                    "Error writing document: $e"));
                                      }),
                                ),
                              ),
                              Icon(
                                Icons.mood,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Buttons

                  Center(
                    child: Center(
                      child: Container(
                          child: const GroupButton(
                        isRadio: false,
                        //controller: _controller,
                        //onSelected: (index, isSelected) =>
                        //print('$index button is selected'),
                        buttons: ["Habit 1", "Habit 2", "Habit 3"],
                      )),
                    ),
                  ),

                  // Log Out Button
                ]));
          }

          // This page runs if snapshot.connectionState != ConnectionState.done
          return Scaffold(
              appBar: AppBar(
                title: Text('Hello, ' + username),
                backgroundColor: Color.fromARGB(255, 255, 184, 189),
                actions: [
                  IconButton(
                      icon: Icon(Icons.logout),
                      tooltip: "log out",
                      onPressed: () {
                        logOut();
                      }),
                ],
              ),
              backgroundColor: Color.fromARGB(255, 255, 240, 240),
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
                        width: 375.0,
                        height: 75.0,
                        child: Center(
                          child: Text(
                            "Hello! It is $weekday, $month $day.\nHow are you doing today?",
                            textScaleFactor: 1.25,
                          ),
                        ))),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 234, 131, 121),
                            Color.fromARGB(255, 240, 175, 130),
                            Color.fromARGB(255, 236, 208, 153),
                            Color.fromARGB(255, 187, 197, 152),
                            Color.fromARGB(255, 154, 185, 136),
                          ]),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        width: 350.0,
                        height: 50.0,
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mood_bad,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  activeTrackColor: Colors.grey[500],
                                  inactiveTrackColor: Colors.grey[300],
                                  thumbColor: Colors.grey[800],
                                ),
                                child: Slider(
                                  value: localSliderVal,
                                  min: 0,
                                  max: 6,
                                  onChanged: (val) {
                                    setState(() {
                                      localSliderVal = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Icon(
                              Icons.mood,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Buttons

                Center(
                  child: Center(
                    child: Container(
                        child: const GroupButton(
                      isRadio: false,
                      //controller: _controller,
                      //onSelected: (index, isSelected) =>
                      //print('$index button is selected'),
                      buttons: ["Habit 1", "Habit 2", "Habit 3"],
                    )),
                  ),
                ),
              ]));
        });
  }
}



/*
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
    */