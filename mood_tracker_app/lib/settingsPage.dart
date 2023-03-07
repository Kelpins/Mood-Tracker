import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Settings")),
        ),
        body: Column(
          children: [
            Text("This is the Settings Page"),
            Text("This is where you change settings"),
          ],
        ));
  }
}
