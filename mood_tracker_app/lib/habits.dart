import 'package:flutter/material.dart';

class Habits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Habits'),
        backgroundColor: Color.fromARGB(255, 255, 184, 189),
      ),
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      body: Center(
        child: Column(
          children: [
            Text("habits page"),
          ]
        ),
      ),
    );
  }
}