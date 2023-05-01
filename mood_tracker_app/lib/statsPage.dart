import 'package:flutter/material.dart';
import 'heatmap.dart';
import 'moodEffect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

  var user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final String email = user.email.toString();
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Center(child: Text("Statistics")),
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
            body: TabBarView(
              children: <Widget>[
                heatmap(email),
                moodEffect(),
              ],
            )));
  }
}
