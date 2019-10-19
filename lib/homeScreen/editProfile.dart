import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samashti_app/model/user.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  User _currentUser;
  bool isLoading = false;
  EditProfile(this._currentUser);
  _EditProfileState createState() => _EditProfileState(_currentUser);
}

class _EditProfileState extends State<EditProfile> {
  User _currentUser;

  bool _isLoading = false;

  _EditProfileState(this._currentUser);

  @override
  Widget build(BuildContext context) {

    TextEditingController classController = new TextEditingController(text: this._currentUser.user_class);
    TextEditingController mobileContraoller = new TextEditingController(text: this._currentUser.user_phone);
    TextEditingController nameContraoller = new TextEditingController(text: this._currentUser.user_name);

    final name = TextFormField(
      controller: nameContraoller,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.account_circle),
          labelText: "Full Name"),
    );

    final contact = TextFormField(
      controller: mobileContraoller,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.phone),
          labelText: "Mobile"),
    );

    final userClass = TextFormField(
      controller: classController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(Icons.bookmark),
          labelText: "Class"),
    );

    final loadingIndicator = Padding(
                  padding: EdgeInsets.all(4.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    backgroundColor: Colors.black,
                  ),
                );    
    
    final updateButtonText = Text("Update", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),);

    final updateButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {

            if(mobileContraoller.text == "" || nameContraoller.text == "" || classController.text == ""){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("All fields are mandetory."),
                  duration: Duration(seconds: 3),
                ));
              }

              if(mobileContraoller.text.length < 9){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Invalid Mobile Number."),
                  duration: Duration(seconds: 3),
                ));
              }
              setState(() {
                _currentUser.user_name = nameContraoller.text;
                _currentUser.user_class = classController.text;
                _currentUser.user_phone = mobileContraoller.text;
                _isLoading = true; 
              });
            http.get("https://samashti.co.in/api/v2/users/update.php?user_chest=" + this._currentUser.user_chest + "&user_email=" + this._currentUser.user_email + "&user_mobile=" + mobileContraoller.text + "&user_name=" + nameContraoller.text + "&user_class=" + classController.text).then((http.Response response) {
            
              var jsonResponse = jsonDecode(response.body);
              if(jsonResponse["action"].toString().compareTo("success") == 0){
                setState(() {
                 _currentUser = User(jsonResponse["data"]);
                  _isLoading = false; 
                 Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Profile information is updated."),
                    duration: Duration(seconds: 3),
                  ));
                });
              }
              setState(() {
                _isLoading = false; 
              });
            });
          },
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isLoading ? loadingIndicator : updateButtonText
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
            name,
            SizedBox(height: 20.0),
            contact,
            SizedBox(height: 20.0),
            userClass,
            SizedBox(height: 24.0),
            updateButton
          ],
        ),
      ),
    );
  }
}