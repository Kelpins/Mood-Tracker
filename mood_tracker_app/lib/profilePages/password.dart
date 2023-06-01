import 'package:flutter/material.dart';

class Password extends StatelessWidget {
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
        title: Text('Password'),
        backgroundColor: Color.fromARGB(255, 255, 184, 189),
      ),
      backgroundColor: Color.fromARGB(255, 255, 245, 245),
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
                hintText: "Enter your new password",
                hintStyle: TextStyle(color: Colors.grey[500]),
              )),
            ),
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
                hintText: "Re-enter your new password",
                hintStyle: TextStyle(color: Colors.grey[500]),
              )),
            ),
            ElevatedButton(
              child: const Text("Done"),
              onPressed:() {
                // KELLAN ADD YOUR STUFF HERE
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                backgroundColor: Color.fromARGB(255, 255, 184, 189)
              ),
            ),
          ],
        ),
      ),
    );
  }
}