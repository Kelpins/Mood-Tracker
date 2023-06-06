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
class HabitsPage2 extends StatefulWidget {
  const HabitsPage2({Key? key}) : super(key: key);

  @override
  State<HabitsPage2> createState() => HabitsPageState();
}

class HabitsPageState extends State<HabitsPage2> {
  var user = FirebaseAuth.instance.currentUser!;
  String username = "";
  String habitMsg = "";
  final _textController = TextEditingController();
  var habits = [];

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String time = DateFormat("jm").format(now);
    String month = DateFormat("MMMM").format(now);
    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEEE').format(now);

    String today = DateFormat('MM-dd-yyyy').format(now);
    bool loaded = false;

    final db = FirebaseFirestore.instance;
    final email = user.email;

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
            habits = moodsDocData["Habits"];

            if (habits.length >= 1) {
              habitMsg =
                  "Hi, $username! You are currently tracking the following habits:\n";
              for (int i = 0; i < habits.length; i++) {
                habitMsg += "\n\t\t- ${habits[i]}";
              }
            } else {
              habitMsg =
                  "Hi, $username! You are currently not tracking any habits. Add a habit by filling out the form below:";
            }

            return Scaffold(
                appBar: AppBar(
                  title: Text("Habits"),
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
                body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    // Rainbow Gradient Slider
                    // Buttons
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 230, 230),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.all(10.0),
                      width: 375.0,
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                          child: Column(children: [
                        SizedBox(height: 8.0),
                        Text("$habitMsg",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                      ])),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 184, 189))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Add a new habit",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[500]),
                                )),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              db
                                  .collection("Users")
                                  .doc("$email")
                                  .collection("Moods")
                                  .doc("Mood")
                                  .update({
                                "Habits": FieldValue.arrayUnion(
                                    [_textController.text]),
                              }).onError(
                                      // ignore: avoid_print
                                      (e, _) => print(
                                          "Error writing document: $e"));
                
                              db
                                  .collection("Users")
                                  .doc("$email")
                                  .collection("Habits")
                                  .doc(_textController.text)
                                  .set({"$today": false}).onError(
                                      // ignore: avoid_print
                                      (e, _) => print(
                                          "Error writing document: $e"));
                
                              _textController.clear();
                              setState(() {});
                            },
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 184, 189)),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ));
          }

          if (!loaded) {
            return Column(children: [
              SizedBox(height: 200),
              Center(child: Text("Loading..."))
            ]);
          }

          // This page runs if snapshot.connectionState != ConnectionState.done
          return Scaffold(
              appBar: AppBar(
                title: Text('Habits'),
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
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 230, 230),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(12.0),
                      width: 375.0,
                      child: Center(
                        child: Column(children: [
                          SizedBox(height: 8.0),
                          Text("$habitMsg",
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          SizedBox(height: 16.0),
                          SizedBox(height: 16.0),
                        ]),
                      )),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 255, 184, 189))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Add a new habit",
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              )),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            db
                                .collection("Users")
                                .doc("$email")
                                .collection("Moods")
                                .doc("Mood")
                                .update({
                              "Habits": FieldValue.arrayUnion(
                                  [_textController.text]),
                            }).onError(
                                    // ignore: avoid_print
                                    (e, _) =>
                                        print("Error writing document: $e"));
              
                            db
                                .collection("Users")
                                .doc("$email")
                                .collection("Habits")
                                .doc(_textController.text)
                                .update({}).onError(
                                    // ignore: avoid_print
                                    (e, _) =>
                                        print("Error writing document: $e"));
              
                            _textController.clear();
                            setState(() {});
                          },
                          child: Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor:
                                  Color.fromARGB(255, 255, 184, 189)),
                        ),
                      ],
                    ),
                  ),
              
                  // Buttons
                ]),
              ));
        });
  }
}
