import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/loginScreen/lostPassword.dart';
import 'package:samashti_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String deviceToken = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _isLoading = false;

  Future<String> _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userChest = prefs.getString("chest_no");
    if (userChest == null) {
      return "";
    }
    return userChest;
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) => deviceToken = token);
    _checkUser().then((userChest) {
      if (userChest != "") {
        Navigator.of(context).pushReplacementNamed('/SamashtiApp');
      }
    });
  }

  bool isEmail(String em) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(em))
      return true;
    else
      return false;
  }

  _saveUser(String userChest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("chest_no", userChest);
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
          labelText: "Email Address"),
    );

    final loadingIndicator = CircularProgressIndicator(
      backgroundColor: Colors.black,
      strokeWidth: 2.0,
    );

    final loginText =
        Text('Log In', style: TextStyle(color: Colors.white, fontSize: 20.0));

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        prefixIcon: Icon(
          Icons.vpn_key,
        ),
        labelText: 'Password',
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {
            if (isEmail(emailController.text)) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Invalid email address."),
                duration: Duration(seconds: 3),
              ));
              return;
            }
            if (emailController.text.isEmpty ||
                passwordController.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Email or password is required."),
                duration: Duration(seconds: 3),
              ));
            } else if (emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {
              setState(() {
                _isLoading = true;
              });
              http
                  .get(
                      "http://samashti.co.in/api/v2/users/read.php?user_email=" +
                          emailController.text +
                          "&user_password=" +
                          passwordController.text +
                          "&user_device=" +
                          deviceToken)
                  .then((http.Response response) {
                var jsonResponse = jsonDecode(response.body);
                if (jsonResponse["action"].toString().compareTo("failed") ==
                    0) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Invalid Email or Password, please try again."),
                    duration: Duration(seconds: 3),
                  ));
                } else {
                  User loginUser = new User(jsonResponse["data"]);
                  _saveUser(loginUser.user_chest);
                  Navigator.of(context).pushReplacementNamed('/SamashtiApp');
                }
                setState(() {
                  _isLoading = false;
                });
              });
            }
          },
          padding: EdgeInsets.all(12),
          child: Column(
            children: <Widget>[!_isLoading ? loginText : loadingIndicator],
          )),
    );

    final lostPasswordButton = FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LostPassword()));
      },
      child: Text("Forgot Password?"),
    );

    final info = Text(
      "Login to account",
      style: Theme.of(context).textTheme.headline,
    );
    
    final caption = Text(
      "Get access to your profile, notifications and much more.",
      style: Theme.of(context).textTheme.caption,
    );

    return Center(
      child: Container(
        color: Color.fromRGBO(239, 239, 239, 1),
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            info,
            caption,
            SizedBox(height: 20.0),
            email,
            SizedBox(height: 20.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            Row(
              children: <Widget>[lostPasswordButton],
            ),
          ],
        ),
      ),
    );
  }
}
