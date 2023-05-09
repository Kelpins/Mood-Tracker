import 'package:flutter/material.dart';

// basic structure from ChatGPT
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Profile'),
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
      children: <Widget>[
        // LINK TO PROFILE PAGE
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Name'),
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
            title: Text('Username'),
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
            title: Text('Email'),
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
        Card(
          child: ListTile(
            leading: Icon(Icons.mood),
            title: Text('Password'),
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
