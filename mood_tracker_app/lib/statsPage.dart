import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker_app/signin.dart';
import 'heatmap.dart';
import 'moodEffect2.dart';
import 'firebase_options.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // signs out and sends to the signin page
    void logOut() {
      FirebaseAuth.instance.signOut();
      //Navigator.pop(context);
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: SignIn(), withNavBar: false);
    }

    if (user == null) {
      return Text("BORK"); // kellan-speak for ERROR
    } else {
      final String email = user!.email.toString();
      return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                  toolbarHeight: 50,
                  title: Text("Statistics"),
                  backgroundColor: Color.fromARGB(255, 255, 184, 189),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.logout),
                        tooltip: "log out",
                        onPressed: () {
                          logOut();
                        }),
                  ],

                  // tabs betwen heatmap and bar chart
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.calendar_month),
                      ),
                      Tab(
                        icon: Icon(Icons.align_horizontal_left_rounded),
                      ),
                    ],
                  )),
              backgroundColor: Color.fromARGB(255, 255, 240, 240),
              body: TabBarView(
                children: <Widget>[
                  // in heatmap.dart
                  heatmap(email),
                  // in moodEffect2.dart
                  const barChart(),
                ],
              )));
    }
  }
}
