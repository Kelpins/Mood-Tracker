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
      ),
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