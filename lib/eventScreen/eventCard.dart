import 'package:flutter/material.dart';
import 'package:samashti_app/eventScreen/evetnDetails.dart';
import 'package:samashti_app/model/event.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event currentEvent;

  const EventCard(this.currentEvent);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetails(this.currentEvent)));
      },
      child: Container(
        height: 200.0,
        width: 300.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  NetworkImage(
                'https://samashti.co.in/' + currentEvent.event_image),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            ),
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      currentEvent.event_name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        currentEvent.event_categoryName,
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ),
                    Container(
                      height: 2.0,
                      color: Theme.of(context).accentColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        DateFormat("dd MMM, hh:mm a").format(
                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                .parse(currentEvent.event_start)),
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      ),
                    ),
                  ],
                ))),
      ),
    ));
  }
}
