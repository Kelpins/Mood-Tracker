import 'package:flutter/material.dart';

// Structure and styling from YouTube video by Mitch Koko
// https://youtu.be/Dh-cTQJgM-Q
class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // spacing
              SizedBox(height: 50),

              // logo
              Image.asset(
                'images/logo.png',
                width: 100,
                height: 100,
              ),

              SizedBox(height: 50),

              Text(
                'Welcome back! How have you been?',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                )
              ),

              SizedBox(height: 25),

              // username textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  )
                ),
              ),

              SizedBox(height: 10),

              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  )
                ),
              ),
          ]),
        ),
      )
    );
  }
}
