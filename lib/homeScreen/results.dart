import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Results extends StatefulWidget {
  Results({Key key}) : super(key: key);

  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<Widget> allResults = [
    Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ))
  ];

  @override
  void initState() {
    super.initState();

    http
        .get("https://samashti.co.in/api/v3/results/results.php")
        .then((http.Response response) {
      allResults = [];
      var jsonResponse = jsonDecode(response.body);
      for (var event in jsonResponse) {
        List<Widget> winnersList = [];
        for (var winners in event["results"]) {
          winnersList.add(ListTile(
            title: Text(
              winners["name"].toString(),
              style: Theme.of(context).textTheme.subhead,
            ),
            subtitle: Text(winners["anv"].toString()),
            leading: Icon(
              Icons.account_circle,
              size: 50.0,
            ),
          ));
        }
        allResults.add(Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(0.0),
              child: ExpansionTile(
                backgroundColor: Color.fromRGBO(219, 219, 219, 0.5),
                title: Text(event["event_name"].toString()),
                children: winnersList,
              ),
            ),
          ),
        ));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Image.asset("assets/anv_logo.png", height: 100.0,),
                ),
                Expanded(
                  child: Image.asset("assets/s_logo.png", height: 100.0,),
                )
              ],
            )
          ),
          Column(
            children: allResults,
          ),
        ],
      ),
    );
  }
}
