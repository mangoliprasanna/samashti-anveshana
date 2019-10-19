import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RoundList extends StatefulWidget {
  var jsonData;
  RoundList(this.jsonData);

  _RoundListState createState() => _RoundListState(jsonData);
}

class _RoundListState extends State<RoundList> {
  var jsonData;
  _RoundListState(this.jsonData);

  List<Widget> _eventGallery = [
    Center(
      child: CircularProgressIndicator(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    _eventGallery = [];
    for (var data in jsonData["rounds"]) {
      _eventGallery.add(ListTile(
        title: Text(data["round_name"]),
        leading: Icon(
          Icons.attach_file,
          size: 30.0,
        ),
        trailing: Icon(
          Icons.file_download,
          size: 30.0,
        ),
        onTap: () async {
          String url = "https://samashti.co.in/" + data["round_file"];
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        subtitle: Text(
          DateFormat("dd MMM y,  hh:mm a").format(
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(data["round_start"]),
          ),
        ),
      ));
    }
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
            child: Text(
              "Event Rounds",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
          ),
          Container(
            child: Column(children: _eventGallery),
          ),
        ],
      ),
    );
  }
}
