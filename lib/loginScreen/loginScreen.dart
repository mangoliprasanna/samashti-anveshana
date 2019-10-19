import 'package:flutter/material.dart';
import 'package:samashti_app/loginScreen/login.dart';
import 'package:samashti_app/loginScreen/register.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: AppBar(
            actions: <Widget>[
              Container(
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/SamashtiApp');
                  },
                  splashColor: Theme.of(context).accentColor,
                  child: Text("GUEST", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ),),
                ),
              ),
            ],
            flexibleSpace: Padding(
              child: Image.asset(
                "assets/l_logo.png",
                height: 120.0,
              ),
              padding: EdgeInsets.only(top: 40.0),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "LOGIN"),
                Tab(text: "SIGN UP")
              ],
            ),
            centerTitle: true,
          ),
        ),
        body: TabBarView(
          children: [
            Login(),
            Register()
          ],
        ),
      ),
    );
  }
}
