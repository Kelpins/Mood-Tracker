import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'main.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

// Structure and styling from YouTube video by Mitch Koko
// https://youtu.be/Dh-cTQJgM-Q
class _SignInState extends State<SignIn> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            
                // header
                Text('Welcome back! How have you been?',
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
            
                // link to the signup page
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: Text(
                          'Tap here to sign up!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 25),
            
                // log in button
                Center(
                  child: ElevatedButton(
                    child: const Text("Log In"),
                    onPressed: () async {
                      //signUserIn(emailController.text, passwordController.text);
                      final message = await AuthService().login(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Future.delayed(Duration.zero, () {
                        // if everthing goes right, directs to MyStatefulWidget in main.dart
                        if (message!.contains('Success')) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MyStatefulWidget(),
                            ),
                          );
                        } else {
                          // if there are any errors, creates an error message
                          errorMessage = message;
                          print(errorMessage);
                        }
                      });
                      // "reloads" page so the correct error message displays
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Color.fromARGB(255, 255, 184, 189)
                    ),
                  ),
                ),
            
                // displays error message
                Text(errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ]),
            ),
          ),
        ));
  }
}
