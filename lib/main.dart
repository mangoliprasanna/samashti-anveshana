

import 'package:flutter/material.dart';
import 'package:samashti_app/homeScreen/homeScreen.dart';
import 'package:samashti_app/loginScreen/loginScreen.dart';

void main() => runApp(Samashti());

class Samashti extends StatefulWidget {
  Samashti({Key key}) : super(key: key);
  _SamashtiState createState() => _SamashtiState();
}

class _SamashtiState extends State<Samashti> {
  final GlobalKey<NavigatorState> locator = new GlobalKey<NavigatorState>();
  var routeBuilder = <String, WidgetBuilder> {
      '/SamashtiApp': (BuildContext context) => HomeScreen(),
      '/SamashtiAppLogin': (BuildContext context) => LoginScreen()
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Samashti - The Student Council",
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          accentColor: Color.fromRGBO(242, 174, 43, 1)),
      home: LoginScreen(),
      routes: routeBuilder,
    );
  }
}
