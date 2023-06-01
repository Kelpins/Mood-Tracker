import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker_app/signin.dart';
import 'heatmap.dart';
import 'moodEffect.dart';
import 'moodEffect2.dart';
import 'firebase_options.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    void logOut() {
      FirebaseAuth.instance.signOut();
      //Navigator.pop(context);
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: SignIn(), withNavBar: false);
    }

    if (user == null) {
      return Text("BORK");
    } else {
      final String email = user!.email.toString();
      return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
              appBar: AppBar(
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
                  heatmap(email),
                  BarChartSample5(),
                ],
              )));
    }
  }
}
