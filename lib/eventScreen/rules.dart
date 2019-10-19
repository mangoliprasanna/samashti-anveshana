import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Rules extends StatelessWidget {
  String _url;
  Rules(this._url);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
          child: Text(
            "Event Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          constraints: BoxConstraints(maxHeight: 350.0),
          child: WebView(
            initialUrl: this._url,
          ),
        )
      ],
    );
  }
}
