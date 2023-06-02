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

//legal app
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!;
  double localSliderVal = 3;
  String username = "";
  String habitDay = "";
  String habitMsg = "No Habits Found.\nGo to settings to add a habit.";
  var habits = [];
  var habitMatching = [];

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    bool loaded = false;
    String time = DateFormat("jm").format(now);
    String month = DateFormat("MMMM").format(now);
    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEEE').format(now);

    String today = DateFormat('MM-dd-yyyy').format(now);

    final db = FirebaseFirestore.instance;
    final email = user.email;
    const habitName = "Taking Naps";

    var _controller = GroupButtonController();
    var _controller2 = GroupButtonController();

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

          loaded = true;

          //Data is output to the user
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> moodsDocData =
                snapshot.data!.data() as Map<String, dynamic>;
            // reads everything from the Mood part of the database
            username = moodsDocData["username"];
            habitDay = moodsDocData["HabitDay"];
            habits = moodsDocData["Habits"];
            habitMatching = moodsDocData["HabitMatchingToday"];

            // if you run the program on a new day
            if (habitDay != today) {
              // sets all the HabitMatchingToday things to false, "wipes the slate clean"
              for (int i = 0; i < habitMatching.length; i++) {
                moodsDocData["HabitMatchingToday"][i] = false;
              }
              moodsDocData["HabitDay"] = today;
              db
                  .collection("Users")
                  .doc("$email")
                  .collection("Moods")
                  .doc("Mood")
                  .set(moodsDocData)
                  .onError(
                      // ignore: avoid_print
                      (e, _) => print("Error writing document: $e"));
              username = moodsDocData["username"];
              habitDay = moodsDocData["HabitDay"];
              habits = moodsDocData["Habits"];
              habitMatching = moodsDocData["HabitMatchingToday"];
            }
            try {
              localSliderVal = moodsDocData["$today"];
            } catch (e) {
              localSliderVal = 3;
            }
            List<int> matches = [];
            for (int i = 0; i < habitMatching.length; i++) {
              if (habitMatching[i]) {
                matches.add(i);
              }
            }
            _controller.selectIndexes(matches);

            if (habits.length >= 1) {
              habitMsg = "What are you up to today?";
            }

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
                backgroundColor: Color.fromARGB(255, 255, 250, 250),
                body: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 255, 230, 230),
                          ),
                          margin: const EdgeInsets.all(10.0),
                          width: 375.0,
                          //height: 150.0,
                          child: Center(
                              child: Column(
                            children: [
                              SizedBox(
                                height: 8.0,
                              ),
                              const Text("Hello! How are you?",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                  ),
                                  SizedBox(width: 3),
                                  Text("$weekday, $month $day")
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
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
                                          trackShape:
                                              RoundedRectSliderTrackShape(),
                                          trackHeight: 4.0,
                                          activeTrackColor: Colors.grey[500],
                                          inactiveTrackColor: Colors.grey[300],
                                          thumbColor: Colors.grey[800],
                                        ),
                                        child: Slider(
                                            value: localSliderVal,
                                            min: 0,
                                            max: 6,
                                            onChangeEnd: (value) {
                                              setState(() {
                                                localSliderVal = value;
                                              });
                                            },
                                            onChanged: (val) {
                                              moodsDocData["$today"] = val;

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
                                              setState(() {
                                                localSliderVal = val;
                                              });
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
                          ))),
                      // Rainbow Gradient Slider
                      // Buttons
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 230, 230),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(10.0),
                        width: 375.0,
                        child: Center(
                            child: Column(children: [
                          SizedBox(height: 8.0),
                          Text("$habitMsg",
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          SizedBox(height: 16.0),
                          Container(
                              child: GroupButton(
                                  controller: _controller,
                                  isRadio: false,
                                  buttons: habits,
                                  options: GroupButtonOptions(
                                    selectedShadow: const [],
                                    selectedTextStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.pink[900],
                                    ),
                                    selectedColor: Colors.pink[100],
                                    unselectedShadow: const [],
                                    unselectedColor: Colors.grey[100],
                                    unselectedTextStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[900],
                                    ),
                                    selectedBorderColor: Colors.pink[900],
                                    unselectedBorderColor: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(100),
                                    spacing: 10,
                                    runSpacing: 10,
                                    groupingType: GroupingType.wrap,
                                    direction: Axis.horizontal,
                                    mainGroupAlignment:
                                        MainGroupAlignment.center,
                                    crossGroupAlignment:
                                        CrossGroupAlignment.center,
                                    groupRunAlignment: GroupRunAlignment.center,
                                    textAlign: TextAlign.center,
                                    textPadding: EdgeInsets.zero,
                                    alignment: Alignment.center,
                                    elevation: 0,
                                  ),
                                  onSelected: (value, index, isSelected) {
                                    var current = false;
                                    try {
                                      current = habitMatching[index];
                                      moodsDocData["HabitMatchingToday"]
                                          [index] = !current;
                                    } catch (e) {
                                      current = false;
                                      moodsDocData["HabitMatchingToday"]
                                          .add(true);
                                    }

                                    final habitDocData = {"$today": isSelected};
                                    moodsDocData["HabitDay"] = today;
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
                                    db
                                        .collection("Users")
                                        .doc("$email")
                                        .collection("Habits")
                                        .doc("$value")
                                        .set({}).onError(
                                            // ignore: avoid_print
                                            (e, _) => print(
                                                "Error writing document: $e"));
                                    db
                                        .collection("Users")
                                        .doc("$email")
                                        .collection("Habits")
                                        .doc("$value")
                                        .update(habitDocData)
                                        .onError(
                                            // ignore: avoid_print
                                            (e, _) => print(
                                                "Error writing document: $e"));
                                  })),
                          SizedBox(height: 16.0),
                        ])),
                      ),
                    ])));
          }

          if (!loaded) {
            return Column(children: [
              SizedBox(height: 200),
              Center(child: Text("Loading..."))
            ]);
          }

          List<int> matches = [];
          for (int i = 0; i < habitMatching.length; i++) {
            if (habitMatching[i]) {
              matches.add(i);
            }
          }
          _controller2.selectIndexes(matches);

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
              backgroundColor: Color.fromARGB(255, 255, 250, 250),
              body: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 230, 230),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(10.0),
                        width: 375.0,
                        //height: 150.0,
                        child: Center(
                            child: Column(children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          const Text("Hello! How are you?",
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                              ),
                              SizedBox(width: 3),
                              Text("$weekday, $month $day")
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
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
                                      onChangeEnd: (value) {
                                        setState(() {
                                          localSliderVal = value;
                                        });
                                      },
                                      onChanged: (val) {
                                        localSliderVal = val;
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
                          )
                        ]))),

                    Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 230, 230),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(10.0),
                        width: 375.0,
                        child: Center(
                          child: Column(children: [
                            SizedBox(height: 8.0),
                            Text("$habitMsg",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            SizedBox(height: 16.0),
                            Container(
                                child: GroupButton(
                              isRadio: false,
                              controller: _controller2,
                              //onSelected: (index, isSelected) =>
                              //print('$index button is selected'),
                              options: GroupButtonOptions(
                                selectedShadow: const [],
                                selectedTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.pink[900],
                                ),
                                selectedColor: Colors.pink[100],
                                unselectedShadow: const [],
                                unselectedColor: Colors.grey[100],
                                unselectedTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[900],
                                ),
                                selectedBorderColor: Colors.pink[900],
                                unselectedBorderColor: Colors.grey[900],
                                borderRadius: BorderRadius.circular(100),
                                spacing: 10,
                                runSpacing: 10,
                                groupingType: GroupingType.wrap,
                                direction: Axis.horizontal,
                                mainGroupAlignment: MainGroupAlignment.center,
                                crossGroupAlignment: CrossGroupAlignment.center,
                                groupRunAlignment: GroupRunAlignment.center,
                                textAlign: TextAlign.center,
                                textPadding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                elevation: 0,
                              ),
                              buttons: habits,
                            )),
                            SizedBox(height: 16.0),
                          ]),
                        )),

                    // Buttons
                  ])));
        });
  }
}
