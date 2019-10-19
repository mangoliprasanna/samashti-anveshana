import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/eventScreen/photoGallery.dart';
import 'package:samashti_app/eventScreen/roundList.dart';
import 'package:samashti_app/eventScreen/rules.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:samashti_app/model/event.dart';

class EventDetails extends StatefulWidget {
  Event _currentEvent;
  EventDetails(this._currentEvent);
  _EventDetailsState createState() => _EventDetailsState(this._currentEvent);
}

class _EventDetailsState extends State<EventDetails> {
  Event _currentEvent;
  _EventDetailsState(this._currentEvent);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userChest;
  bool _canRegister = false;

  Widget _eventGallery = Container(
    child: Center(child: CircularProgressIndicator()),
    padding: EdgeInsets.all(16.0),
  );

  Widget _eventRounds = Container(
    child: Center(child: CircularProgressIndicator()),
    padding: EdgeInsets.all(16.0),
  );

  Future<String> _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userChest = prefs.getString("chest_no");
    if (userChest == null) {
      return "";
    }
    return userChest;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _isregistering = false;

        return (_isregistering == false)
            ? AlertDialog(
                title: Text("Confirmation"),
                content:
                    Text("Are you sure you want to register for this event?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      if (this._userChest != "") {
                        setState(() {
                          _isregistering = true;
                        });
                        http
                            .get(
                                "http://samashti.co.in/api/v2/events/register.php?user_chest=" +
                                    this._userChest +
                                    "&event_id=" +
                                    this._currentEvent.event_id)
                            .then((http.Response response) {
                          var jsonResponse = jsonDecode(response.body);
                          if (jsonResponse["action"]
                                  .toString()
                                  .compareTo("success") ==
                              0) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(jsonResponse["message"])));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(jsonResponse["message"])));
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            this._canRegister = false;
                          });
                        });
                      }
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text("Confirmation"),
                content: Row(
                  children: <Widget>[CircularProgressIndicator()],
                ),
              );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkUser().then((chest_no) {
      if (chest_no == "") {
        http
            .get(
                "http://samashti.co.in/api/v2/events/event-detail.php?user_chest=1&event_token=" +
                    _currentEvent.event_token)
            .then((http.Response response) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse["pictures"].toString().length != 2) {
            setState(() {
              this._eventGallery = PhotoGallery(jsonResponse);
            });
          } else {
            setState(() {
              this._eventGallery = Visibility(
                child: Text("a"),
                visible: false,
              );
            });
          }
          if (jsonResponse["rounds"].toString().length != 2) {
            setState(() {
              this._eventRounds = RoundList(jsonResponse);
            });
          } else {
            setState(() {
              this._eventRounds = Visibility(
                child: Text("a"),
                visible: false,
              );
            });
          }
        });
      } else {
        this._userChest = chest_no;
        http
            .get(
                "http://samashti.co.in/api/v2/events/event-detail.php?user_chest=" +
                    chest_no +
                    "&event_token=" +
                    _currentEvent.event_token)
            .then((http.Response response) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse["pictures"].toString().length != 2) {
            setState(() {
              this._eventGallery = PhotoGallery(jsonResponse);
            });
          } else {
            setState(() {
              this._eventGallery = Visibility(
                child: Text("a"),
                visible: false,
              );
            });
          }
          if (jsonResponse["rounds"].toString().length != 2) {
            setState(() {
              this._eventRounds = RoundList(jsonResponse);
            });
          } else {
            setState(() {
              this._eventRounds = Visibility(
                child: Text("a"),
                visible: false,
              );
            });
          }
          if (jsonResponse["can_registor"].toString().compareTo("0") == 0) {
            setState(() {
              _canRegister = true;
            });
          } else {
            setState(() {
              _canRegister = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Event Details"),
      ),
      floatingActionButton: _canRegister
          ? FloatingActionButton(
              onPressed: () {
                _showDialog();
              },
              tooltip: "Register for Event",
              child: Icon(Icons.person_add, color: Colors.white),
            )
          : Container(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.black,
                padding: EdgeInsets.zero,
                height: 250,
                child: FittedBox(
                  child: FadeInImage(
                    image: NetworkImage(
                      "https://samashti.co.in/" + _currentEvent.event_image,
                    ),
                    placeholder: AssetImage("assets/l_logo.png"),
                  ),
                  fit: BoxFit.fill,
                ),),
            Container(
              color: Colors.black12,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _currentEvent.event_name,
                      style: Theme.of(context).textTheme.headline,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      _currentEvent.event_categoryName,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            _eventGallery,
            _eventRounds,
            ListTile(
              leading: Icon(Icons.watch_later),
              title: Text(DateFormat("dd MMM y,  hh:mm a").format(
                  DateFormat("yyyy-MM-dd HH:mm:ss")
                      .parse(_currentEvent.event_start))),
              subtitle: Text("Event Timings"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(_currentEvent.event_person),
              subtitle: Text(_currentEvent.event_contact),
              onTap: () async {
                String url = "tel:" + this._currentEvent.event_contact;
                if (await UrlLauncher.canLaunch(url)) {
                  await UrlLauncher.launch(url);
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Unable to open app."),
                  ));
                }
              },
            ),
            Rules(
                "https://samashti.co.in/api/v2/events/event-desc.php?event_token=" +
                    this._currentEvent.event_token),
          ],
        ),
      ),
    );
  }
}
