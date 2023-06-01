import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Habits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    final email = user.email;
    final _textController = TextEditingController();

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
      backgroundColor: Color.fromARGB(255, 255, 245, 245),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 184, 189))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
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
                  "Habits": FieldValue.arrayUnion([_textController.text]),
                  "HabitMatchingToday": FieldValue.arrayUnion([false]),
                }).onError(
                        // ignore: avoid_print
                        (e, _) => print("Error writing document: $e"));
              },
              child: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Color.fromARGB(255, 255, 184, 189)),
            ),
          ],
        ),
      ),
    );
  }
}
