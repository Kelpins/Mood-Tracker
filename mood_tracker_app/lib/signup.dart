import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'components/button.dart';
import 'signin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'main.dart';

import 'firebase_options.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

// Structure and styling from YouTube video by Mitch Koko
// https://youtu.be/Dh-cTQJgM-Q
class _SignUpState extends State<SignUp> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String today = DateFormat('MM-dd-yyyy').format(now);
    final db = FirebaseFirestore.instance;

    // sign user in method
    void signUserUp(email, password, name) {
      final initialMoods = {
        "username": name,
        "$today": 3,
      };

      final userInfoDocData = {
        "email": email,
        "Name": name,
        "Password": password,
      };

      // default preferences
      final preferencesDocData = {
        "color": "Colors.blue",
        "Language": "English"
      };

      //USER DATA -- RUNS ON PROFILE CREATE, USER DATA UPDATED
      db
          .collection("Users")
          .doc("$email")
          .collection("User_Info")
          .doc("User")
          .set(userInfoDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //USER PREFERENCES -- RUNS ON PROFILE CREATE, PREFERENCES UPDATED
      db
          .collection("Users")
          .doc("$email")
          .collection("User_Info")
          .doc("Preferences")
          .set(preferencesDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      db
          .collection("Users")
          .doc("$email")
          .collection("Moods")
          .doc("Mood")
          .set(initialMoods)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));
      ;
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 250, 250),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                // spacing
                SizedBox(height: 50),

                // logo
                Image.asset(
                  'images/logo.png',
                  width: 100,
                  height: 100,
                ),

                SizedBox(height: 50),

                // heading
                Text('Welcome to Meliora!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),

                SizedBox(height: 25),

                // email textfield
                MyTextField(
                  key: Key('email'),
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: 10),

                // password textfield
                MyTextField(
                  key: Key('password'),
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 10),

                // name textfield
                MyTextField(
                  key: Key('name'),
                  controller: nameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                SizedBox(height: 10),

                // link to signin page
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        },
                        child: Text(
                          'Tap here to log in!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // signup button
                Center(
                  child: ElevatedButton(
                    child: const Text("Sign Up"),
                    onPressed: () async {
                      // registers user to firebase authenticate
                      final message = await AuthService().registration(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      Future.delayed(Duration.zero, () {
                        if (message!.contains('Success')) {
                          // adds user to firestore database
                          signUserUp(emailController.text,
                              passwordController.text, nameController.text);

                          // goes back to homepage
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MyStatefulWidget()));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                        backgroundColor: Color.fromARGB(255, 255, 184, 189)),
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
