import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
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
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userID = user?.uid;

    return Column(
      children: <Widget>[
        Card(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data?.exists == true) {
                var userData = snapshot.data?.data() as Map<String, dynamic>;
                var username = userData?['username'] as String?;

                return ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Username'),
                  subtitle: Text(username ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                );
              } else {
                return ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Username'),
                  subtitle: Text('Loading...'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                );
              }
            },
          ),
        ),

        // Remaining card widgets
        Card(
          child: ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
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
            leading: Icon(Icons.password),
            title: Text('Password'),
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
