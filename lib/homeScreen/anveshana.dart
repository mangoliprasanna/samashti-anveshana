import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/eventScreen/eventTile.dart';
import 'package:samashti_app/homeScreen/anveshanaDetails.dart';
import 'package:samashti_app/model/event.dart';

class Anveshana extends StatefulWidget {
  Anveshana({Key key}) : super(key: key);
  _AnveshanaState createState() => _AnveshanaState();
}

class _AnveshanaState extends State<Anveshana> {

  Widget _allEvents = Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()));

  @override
  void initState() { 
    super.initState();
    http.get("http://samashti.co.in/api/v2/events/all.php").then((http.Response response) {
      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse["action"].toString().compareTo("success") == 0){
        List<Widget> allEvents = [];
        for (var data in jsonResponse["data"]) {
          allEvents.add(EventTile(Event(data)));
        }
        setState(() {
          _allEvents = Column(
            children: allEvents,
          );
        });

      } else {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnveshanaIntro(),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "All Events",
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
          _allEvents
        ],
      ),
    );
  }
}
