import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String deviceToken = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      this.deviceToken = token;
    });
  }

  _saveUser(String userChest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("chest_no", userChest);
  }

  bool _isLoading = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();

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
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.email),
          labelText: "Email Address"),
    );
    final name = TextFormField(
      controller: nameController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.account_circle),
          labelText: "Full Name"),
    );

    final contact = TextFormField(
      controller: mobileController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.phone),
          labelText: "Mobile"),
    );

    final loadingIndicator = CircularProgressIndicator(
      backgroundColor: Colors.black,
      strokeWidth: 2.0,
    );

    final registerButtonText = Text('Sign up',
        style: TextStyle(color: Colors.white, fontSize: 20.0));

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

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {
            if (emailController.text.isEmpty ||
                nameController.text.isEmpty ||
                mobileController.text.isEmpty ||
                passwordController.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("All Fields are mandetory."),
                duration: Duration(seconds: 3),
              ));
              return;
            }

            if (passwordController.text.length < 4) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Password is too short."),
                duration: Duration(seconds: 3),
              ));
              return;
            }

            if (isEmail(emailController.text)) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Invalid email address."),
                duration: Duration(seconds: 3),
              ));
              return;
            }

            if (passwordController.text.length < 8) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Invalid mobile number."),
                duration: Duration(seconds: 3),
              ));
              return;
            }

            setState(() {
              _isLoading = true;
            });

            String computeUrl = "http://samashti.co.in/api/v2/users/create.php";
            computeUrl += "?user_email=" + emailController.text;
            computeUrl += "&user_name=" + nameController.text;
            computeUrl += "&user_mobile=" + mobileController.text;
            computeUrl += "&user_password=" + passwordController.text;
            computeUrl += "&user_device=" + deviceToken;
            
            http.get(computeUrl).then((http.Response response){
              print(response.body);
              setState(() {
                _isLoading = false; 
              });
              var jsonResponse = jsonDecode(response.body);
              if(jsonResponse["action"].toString().compareTo("success") == 0){
                  _saveUser(jsonResponse["data"]["participent_chest"]);
                  Navigator.of(context).pushReplacementNamed('/SamashtiApp');
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Email Address already present."),
                    duration: Duration(seconds: 3),
                  ));
              }
            });
          },
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              _isLoading ? loadingIndicator : registerButtonText,
              SizedBox(
                width: 10.0,
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 25.0,
              )
            ],
          )),
    );

    final info = Text(
      "Create a new account",
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
            name,
            SizedBox(height: 20.0),
            contact,
            SizedBox(height: 20.0),
            email,
            SizedBox(height: 20.0),
            password,
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[registerButton],
            )
          ],
        ),
      ),
    );
  }
}
