import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/eventScreen/evetnDetails.dart';
import 'package:samashti_app/model/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Announcement extends StatefulWidget {
  Announcement({Key key}) : super(key: key);

  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  Widget _ann = Center(child: CircularProgressIndicator());

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
      http
          .get(
              "" + chestNo)
          .then((http.Response response) {
        var jsonResponse = jsonDecode(response.body);
        List<Widget> allAnn = [];
        for (var data in jsonResponse["data"]) {
          allAnn.add(AnnCard(data));
        }
        setState(() {
          this._ann = ListView(
            children: allAnn,
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _ann);
  }
}

class AnnCard extends StatelessWidget {
  var jsonResponse;

  AnnCard(this.jsonResponse);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        getIcon(int.parse(jsonResponse["ann_subtitle"])),
        size: 40.0,
      ),
      title: Text(jsonResponse["ann_title"]),
      subtitle: Text(jsonResponse["ann_caption"]),
      onTap: () async {
        String action = jsonResponse["ann_action"];
        if (action.contains("EVENT: ")) {
          String eventToken = action.replaceAll("EVENT: ", "");
          http
              .get(
                  "https://samashti.co.in/api/v2/events/event-detail.php?user_chest=1&event_token=" +
                      eventToken)
              .then((http.Response response) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse["action"].toString().compareTo("success") == 0) {
              Event loadEvent = Event(jsonResponse["data"]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetails(loadEvent),
                ),
              );
            }
          });
        }

        if (action.contains("LINK: ")) {
          String url = action.replaceAll("LINK: ", "");
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }
      },
      isThreeLine: true,
    );
  }

  IconData getIcon(int code) {
    return IconData(code, fontFamily: 'MaterialIcons');
  }
}
