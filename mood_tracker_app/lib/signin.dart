import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'components/button.dart';
import 'signup.dart';

// Structure and styling from YouTube video by Mitch Koko
// https://youtu.be/Dh-cTQJgM-Q
class Signin extends StatelessWidget {
  Signin({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
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

              Text('Welcome back! How have you been?',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  )),

              SizedBox(height: 25),

              // username textfield
              MyTextField(
                key: Key('username'),
                controller: usernameController,
                hintText: 'Username',
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
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text(
                        'Create an account.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              MyButton(
                onTap: signUserIn,
                text: "Sign In",
              ),
            ]),
          ),
        ));
  }
}
