import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textfield.dart';

class Username extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    final email = user.email;
    var usernameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Username'),
        backgroundColor: Color.fromARGB(255, 255, 184, 189),
      ),
      backgroundColor: Color.fromARGB(255, 255, 245, 245),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: MyTextField(
                key: Key('username'),
                controller: usernameController,
                hintText: 'New Username',
                obscureText: false,
              ),
            ),
            ElevatedButton(
              child: const Text("Done"),
              onPressed: () {
                db
                    .collection("Users")
                    .doc("$email")
                    .collection("Moods")
                    .doc("Mood")
                    .set({
                  "username": usernameController.text
                }, SetOptions(merge: true)).onError(
                        // ignore: avoid_print
                        (e, _) => print("Error writing document: $e"));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Successfully changed username to ${usernameController.text}!"),
                  ),
                );
                usernameController.clear();
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: Color.fromARGB(255, 255, 184, 189)),
            ),
          ],
        ),
      ),
    );
  }
}
