import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    void logOut() {
      FirebaseAuth.instance.signOut();
      //Navigator.pop(context);
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: SignIn(), withNavBar: false);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                tooltip: "log out",
                onPressed: () {
                  logOut();
                }),
          ],
        ),
        body: const Tiles(),
      ),
    );
  }
}

class Tiles extends StatelessWidget {
  const Tiles({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // LINK TO PROFILE PAGE
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Manage your account'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Habits'),
            subtitle: Text('Customize your habit settings'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.mood),
            title: Text('Moods'),
            subtitle: Text('Customize your mood settings'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ),
      ],
    );
  }
}
