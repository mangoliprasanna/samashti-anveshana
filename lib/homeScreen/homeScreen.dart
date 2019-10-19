import 'package:flutter/material.dart';
import 'package:samashti_app/homeScreen/anveshana.dart';
import 'package:samashti_app/homeScreen/feed.dart';
import 'package:samashti_app/homeScreen/profile.dart';
import 'package:samashti_app/homeScreen/results.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Feed(),
    Anveshana(),
    Results(),
    Profile()
  ];
  clearUser() async {
  final pref = await SharedPreferences.getInstance();
  await pref.clear();
  Navigator.of(context).pushReplacementNamed('/SamashtiAppLogin');
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Samashti - The Student Council",
      theme: ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.red,
      primaryColor: Colors.black,
      accentColor: Color.fromRGBO(242, 174, 43, 1)),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Samashti"),
          actions: <Widget>[
            InkWell(
              onTap: () {
                clearUser();
              },
              child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.power_settings_new),
            ),
            )
          ],
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).accentColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/anv.png", height: 29.0,),
              title: Text('Anveshana'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.filter_frames), title: Text('Results')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile'))
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
