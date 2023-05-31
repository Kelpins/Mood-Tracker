import 'package:flutter/material.dart';
import 'components/textfield.dart';

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
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 184, 189))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[500]),
              )),
            ),
          ]
        ),
      ),
    );
  }
}