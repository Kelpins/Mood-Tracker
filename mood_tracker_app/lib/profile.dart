import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_tracker_app/signin.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'profilePages/username.dart';
import 'profilePages/password.dart';

class Profile extends StatelessWidget {
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
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 255, 184, 189),
      ),
      backgroundColor: Color.fromARGB(255, 255, 250, 250),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AccountInfo(),
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.grey[200],
      child: Icon(Icons.person, size: 60, color: Colors.grey[700]),
    );
  }
}

class AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void logOut() {
      FirebaseAuth.instance.signOut();
      //Navigator.pop(context);
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: SignIn(), withNavBar: false);
    }

    final User? user = FirebaseAuth.instance.currentUser;
    final String? userID = user?.uid;

    return Column(
      children: <Widget>[
        Card(
            child: ListTile(
          leading: Icon(Icons.create),
          title: Text('Change Username'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Username()),
            );
          },
        )),
        SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: Icon(Icons.password),
            title: Text('Change Password'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Password()),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              logOut();
            },
          ),
        ),
      ],
    );
  }
}
