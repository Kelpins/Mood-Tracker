import 'package:flutter/material.dart';

// basic structure from ChatGPT
class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup>{
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ProfilePicture(),
            ),
            AccountInfo(),
          ],
        )));
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
    return Column(
      children: [
        ListTile(
            title: Text('Name'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {}),
        Divider(),
        ListTile(
            title: Text('Username'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {}),
        Divider(),
        ListTile(
            title: Text('Email'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {}),
        Divider(),
        ListTile(
            title: Text('Password'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {}),
      ],
    );
  }
}
