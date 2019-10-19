import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:samashti_app/eventScreen/eventCard.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/homeScreen/feedCard.dart';
import 'package:samashti_app/model/event.dart';
import 'package:samashti_app/model/feed.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Widget _latestFeed = Center(child: CircularProgressIndicator());
  Widget _myEvents = Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()));

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
    getUser().then((chestNo) {
      if (chestNo == null || chestNo == "") {
        setState(() {
          this._myEvents = Visibility(
            child: Text("asd"),
            visible: false,
          );
        });
      } else {
        http
            .get(
                'https://samashti.co.in/api/v2/events/myevents.php?user_chest=' +
                    chestNo)
            .then((response) {
          var jsonResponse = jsonDecode(response.body);
          List<Widget> allEvents = [];
          for (var data in jsonResponse["data"]) {
            allEvents.add(EventCard(Event(data)));
          }
          if (allEvents.length > 0) {
            setState(() {
              this._myEvents = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      "My Events",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10.0,
                    ),
                    height: 200.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: allEvents,
                    ),
                  ),
                ],
              );
            });
          } else {
            this._myEvents = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                  child: Text(
                    "My Events",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  height: 50.0,
                  child: Center(
                    child: Text("No Events"),
                  ),
                ),
              ],
            );
          }
        });
      }
      http
          .get('https://samashti.co.in/api/v3/feeds/read.php?user_chest=' +
              chestNo)
          .then((http.Response response) {
        var jsonResponse = jsonDecode(response.body);
        List<Widget> allFeeds = [];
        for (var data in jsonResponse["data"]) {
          allFeeds.add(FeedCard(prefix0.Feed(data), chestNo));
        }
        allFeeds.add(Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).accentColor,
                  size: 50.0,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "You're All Caught Up",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold ,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              ],
            ),
            padding: EdgeInsets.all(16.0),
          ),
        ));
        setState(() {
          this._latestFeed = Column(
            children: allFeeds,
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(219, 219, 219, 1),
        ),
        child: ListView(
          children: <Widget>[_myEvents, _latestFeed],
        ));
  }
}
