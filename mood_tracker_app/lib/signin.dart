import 'package:flutter/material.dart';
import 'components/textfield.dart';
import 'components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'auth_service.dart';
import 'home_page.dart';

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
/*
  List<String> docIDs = [];

  // get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
            }));
  }

  // sign user in method
  void signUserIn(email, password) {}
  

  // from https://www.youtube.com/watch?v=TcwQ74WVTTc
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('Users').snapshots();

    */

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
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        'Sign into an existing account.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

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
                      if (message!.contains('Success')) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
              /*
              Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: users,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong.');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        }

                        final data = snapshot.requireData;

                        return ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return Text('users: ${data.docs[index]}');
                            });
                      }))
                      */
            ]),
          ),
        ));
  }
}
