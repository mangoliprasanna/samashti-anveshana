import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/model/user.dart';

class ChangePassword extends StatefulWidget {

  User _currentUser;

  ChangePassword(this._currentUser);

  _ChangePasswordState createState() => _ChangePasswordState(this._currentUser);
}

class _ChangePasswordState extends State<ChangePassword> {

  User _currentUser;
  _ChangePasswordState(this._currentUser);

  @override
  Widget build(BuildContext context) {

    TextEditingController currentPassController = new TextEditingController();
    TextEditingController newPassController = new TextEditingController();
    TextEditingController confirmPassController = new TextEditingController();

    final currentPassword = TextFormField(
      controller: currentPassController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.lock_open),
          labelText: "Current Password"),
    );
    final newPassword = TextFormField(
      controller: newPassController,
      keyboardType: TextInputType.text,
      validator: (val) => val.length < 4 ? 'Password too short.' : null,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.lock),
          labelText: "New Password"),
    );

    final confirmPassword = TextFormField(
      controller: confirmPassController,
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.check),
          labelText: "Confirm Password"),
    );

    final updateButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {

            if(newPassController.text == "" || confirmPassController.text == "" || currentPassController.text == ""){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("All Fields are mandetory."),
                duration: Duration(seconds: 3),
              ));
              return;
            }

            if(newPassController.text.length < 4){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Password should be at least 6 characters."),
                duration: Duration(seconds: 3),
              ));
            }

            if(newPassController.text != confirmPassController.text){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("New Password mismatch. Please check and try again."),
                duration: Duration(seconds: 3),
              ));
              return;
            }
            http.get("https://samashti.co.in/api/v2/users/update.php?user_email="+_currentUser.user_email+"&user_chest="+_currentUser.user_chest+"&n_pass=" + newPassController.text + "&cu_pass=" + currentPassController.text).then((http.Response response) {
              var jsonResponse = jsonDecode(response.body);
              if(jsonResponse["action"].toString().compareTo("failed") == 0){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(jsonResponse["message"]),
                  duration: Duration(seconds: 3),
              ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("New Password Updated."),
                  duration: Duration(seconds: 3),
                ));
                setState(() {
                  currentPassController.text = "";
                  confirmPassController.text = "";
                  currentPassController.text = "";
                });
              }
              print(response.body);
            });
            
          },
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Update Password',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ],
          )),
    );
    return Center(
      child: Container(
        color: Color.fromRGBO(239, 239, 239, 1),
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            currentPassword,
            SizedBox(height: 20.0),
            newPassword,
            SizedBox(height: 20.0),
            confirmPassword,
            SizedBox(height: 24.0),
            updateButton
          ],
        ),
      ),
    );
  }
}