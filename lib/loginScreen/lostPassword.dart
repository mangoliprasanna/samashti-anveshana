import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LostPassword extends StatefulWidget {
  LostPassword({Key key}) : super(key: key);

  _LostPasswordState createState() => _LostPasswordState();
}

class _LostPasswordState extends State<LostPassword> {
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();

  bool isEmail(String em) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(em))
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.email),
          labelText: "Enter Email Address"),
    );

    final loadingIndicator = CircularProgressIndicator(
      backgroundColor: Colors.black,
      strokeWidth: 2.0,
    );

    final lostText = Text('Reset Password',
        style: TextStyle(color: Colors.white, fontSize: 20.0));

    final resetButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {
            if (isEmail(emailController.text)) {
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text('Invalid email address.')));
              return;
            }

            setState(() {
              _isLoading = true;
            });
            http
                .get(
                    "https://samashti.co.in/api/v2/users/update.php?reset_email=" +
                        emailController.text)
                .then((http.Response response) {
              var jsonResponse = jsonDecode(response.body);
              setState(() {
                _isLoading = false;
              });
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text(jsonResponse["message"])));
            });
          },
          padding: EdgeInsets.all(12),
          child: Column(
            children: <Widget>[!_isLoading ? lostText : loadingIndicator],
          )),
    );

    final info = Text(
      "Lost Password ?",
      style: Theme.of(context).textTheme.headline,
    );

    final caption = Text(
      "Enter your registered email address to reset password.",
      style: Theme.of(context).textTheme.caption,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Center(
        child: Container(
          color: Color.fromRGBO(239, 239, 239, 1),
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              info,
              caption,
              SizedBox(height: 20.0),
              email,
              SizedBox(height: 20.0),
              resetButton
            ],
          ),
        ),
      ),
    );
  }
}
