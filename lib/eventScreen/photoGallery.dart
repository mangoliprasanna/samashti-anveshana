import 'package:flutter/material.dart';
import 'package:samashti_app/eventScreen/fullPicture.dart';

class PhotoGallery extends StatefulWidget {
  var imageJson;
  PhotoGallery(this.imageJson);

  _PhotoGalleryState createState() => _PhotoGalleryState(this.imageJson);
}

class _PhotoGalleryState extends State<PhotoGallery> {
  var imageJson;

  List<Widget> _eventGallery = [
    Center(
      child: CircularProgressIndicator(),
    )
  ];

  _PhotoGalleryState(this.imageJson);
  @override
  Widget build(BuildContext context) {
    _eventGallery = [];
    int i = 0;
    for (var data in imageJson["pictures"]) {
      _eventGallery.add(
        Container(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullPicture(data["picture_image"]),
                ),
              );
            },
            child: FadeInImage(
              image: NetworkImage(
                  "" + data["picture_image"]),
              placeholder: AssetImage("assets/placeholder.png"),
            ),
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              "Event Pictures",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            height: 150.0,
            child: ListView(
                scrollDirection: Axis.horizontal, children: _eventGallery),
          ),
        ],
      ),
    );
  }
}
