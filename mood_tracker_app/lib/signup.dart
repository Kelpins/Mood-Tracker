import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'components/button.dart';
import 'signin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';
import 'home_page.dart';

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

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String today = DateFormat('MM-dd-yyyy').format(now);
    final db = FirebaseFirestore.instance;
    const habitName = "Taking Naps";

    // sign user in method
    void signUserUp(email, password) {
      final dailyDocData = {
        "Habit_1": true,
        "Habit_2": false,
        "Habit_3": false,
        "mood": 5,
      };

      final habitDocData = {
        "Description": "Thirty minute nap at least twice a week",
        "Icon": "Icon(Icons.bed)",
        "Name": "Taking Naps",
        "Timing": "weekly"
      };

      final moodsDocData = {
        "$today": 4,
        //PAST MOOD DOC DATA -- TO READ
      };

      final userInfoDocData = {
        "email": email,
        "Name": "Kellan",
        "Password": password,
      };

      final preferencesDocData = {
        "color": "Colors.blue",
        "Language": "English"
      };

      /*DAILY -- RUNS AT END OF EVERY DAY
      db
          .collection("Users")
          .doc("$email")
          .collection("Daily")
          .doc("$today")
          .set(dailyDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //HABITS -- RUNS ON NEW HABIT CREATED
      db
          .collection("Users")
          .doc("$email")
          .collection("Habits")
          .doc("$habitName")
          .set(habitDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));

      //MOODS -- RUNS ON MOOD UPDATED
      db
          .collection("Users")
          .doc("$email")
          .collection("Moods")
          .doc("Mood")
          .set(moodsDocData)
          .onError(
              // ignore: avoid_print
              (e, _) => print("Error writing document: $e"));*/

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
    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
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

              Text('Welcome to Meliora!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  )),

              SizedBox(height: 25),

              // username textfield
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

              Center(
                child: ElevatedButton(
                    child: const Text("Sign Up"),
                    /*
                  onPressed: () {
                    signUserUp(emailController.text, passwordController.text);
                  },
                  */
                    onPressed: () async {
                      final message = await AuthService().registration(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      Future.delayed(Duration.zero, () {
                        if (message!.contains('Success')) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      });
                    }),
              )
            ]),
          ),
        ));
  }
}
