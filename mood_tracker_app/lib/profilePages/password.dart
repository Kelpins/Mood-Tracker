import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textfield.dart';

class Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    final passwordController = TextEditingController();
    final oldPasswordController = TextEditingController();
    final passwordCheckController = TextEditingController();

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
            SizedBox(height: 35.0),
            MyTextField(
              key: Key('password'),
              controller: oldPasswordController,
              hintText: 'Old Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            MyTextField(
              key: Key('password'),
              controller: passwordController,
              hintText: 'New Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            MyTextField(
              key: Key('passwordCheck'),
              controller: passwordCheckController,
              hintText: 'Repeat New Password',
              obscureText: true,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              child: const Text("Done"),
              onPressed: () {
                if (passwordController.text != passwordCheckController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Passwords did not match."),
                    ),
                  );
                } else {
                  var password = passwordController.text;
                  //Pass in the password to updatePassword.
                  user.updatePassword(password).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Successfully changed password!"),
                      ),
                    );
                    passwordCheckController.clear();
                    passwordController.clear();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Password can't be changed" + error.toString()),
                      ),
                    );
                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                  });
                }
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
