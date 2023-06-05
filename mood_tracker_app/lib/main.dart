import 'package:flutter/material.dart';
import 'package:mood_tracker_app/settings.dart';
import 'home_page.dart';
import 'statsPage.dart';
import 'profile.dart';
import 'signup.dart';
import 'signin.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  //static const TextStyle optionStyle =
  //TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    StatsPage(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [HomePage(), StatsPage(), Settings()];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Color.fromARGB(255, 255, 140, 140),
          inactiveColorPrimary: Color.fromARGB(255, 255, 184, 189),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.analytics_outlined),
          title: ("Statistics"),
          activeColorPrimary: Color.fromARGB(255, 255, 140, 140),
          inactiveColorPrimary: Color.fromARGB(255, 255, 184, 189),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: Color.fromARGB(255, 255, 140, 140),
          inactiveColorPrimary: Color.fromARGB(255, 255, 184, 189),
        ),
      ];
    }

    PersistentTabController tabController;

    tabController = PersistentTabController(initialIndex: 0);

    // checking if user is signed in
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        body: Center(
          child: PersistentTabView(
            context,
            onItemSelected: (value) => setState(() {}),
            stateManagement: false,
            controller: tabController,
            screens: _buildScreens(),
            items: _navBarsItems(),
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
          ),
        ),
      );
    } else {
      // if user is not signed in, show sign-in page
      return SignIn();
    }
  }
}
