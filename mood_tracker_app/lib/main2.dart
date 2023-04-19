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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
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
    SignUp(),
    SignIn(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [HomePage(), StatsPage(), Settings(), SignUp(), SignIn()];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.orange,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.analytics_outlined),
          title: ("Statistics"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.orange,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.orange,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.key),
          title: ("Sign In"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.orange,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.lock),
          title: ("Sign Up"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.orange,
        ),
      ];
    }

    PersistentTabController tabController;

    tabController = PersistentTabController(initialIndex: 0);

    return Scaffold(
      body: Center(
        child: PersistentTabView(
          context,
          controller: tabController,
          screens: _buildScreens(),
          items: _navBarsItems(),
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Signup',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Sign In',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,*/
    );
  }
}
