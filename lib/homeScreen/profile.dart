import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/homeScreen/changePassword.dart';
import 'package:samashti_app/homeScreen/editProfile.dart';
import 'package:samashti_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _currentUser;
  Widget _emptyUser = Center(
    child: CircularProgressIndicator(),
  );
  List<Widget> _profileSection = [];

  Future<String> getUser() async {
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
    getUser().then((chest_no) {
      if (chest_no == "") {
        setState(() {
          _emptyUser = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.account_box,
                  size: 100.0,
                  color: Colors.grey,
                ),
                Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Login to access this section.",
                      style: Theme.of(context).textTheme.headline,
                    ))
              ],
            ),
          );
        });
      }
      http
          .get("" +
              chest_no)
          .then((http.Response response) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse["action"].toString().compareTo("success") == 0) {
          setState(() {
            _currentUser = User(jsonResponse["data"]);
            _profileSection.add(EditProfile(_currentUser));
            _profileSection.add(ChangePassword(_currentUser));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return _emptyUser;
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130.0),
            child: AppBar(
              flexibleSpace: Padding(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0.0, left: 16.0),
                      child: Icon(Icons.account_circle,
                          size: 60.0, color: Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 13.0),
                          child: Text(
                            _currentUser.user_name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 13.0, top: 4.0),
                          child: Text(
                            _currentUser.user_email,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 13.0, top: 8.0),
                          child: Text(
                            "ANV - " + _currentUser.user_chest,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: 10.0),
              ),
              bottom: TabBar(
                tabs: [Tab(text: "PROFILE"), Tab(text: "CHANGE PASSWORD")],
              ),
              centerTitle: true,
            ),
          ),
          body: TabBarView(
            children: _profileSection,
          ),
        ),
      );
    }
  }
}
