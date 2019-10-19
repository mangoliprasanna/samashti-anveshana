import 'package:flutter/material.dart';
import 'package:samashti_app/eventScreen/evetnDetails.dart';
import 'package:samashti_app/model/event.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  Event _currentEvent;
  EventTile(this._currentEvent);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this._currentEvent.event_name),
      subtitle: Text(this._currentEvent.event_categoryName),
      trailing: Text(
        DateFormat("dd MMM \n hh:mm a")
            .format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(this._currentEvent.event_start)),
        style: TextStyle(fontSize: 12.0),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetails(this._currentEvent)));
      },
    );
  }
}
