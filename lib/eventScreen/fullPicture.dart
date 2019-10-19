import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';

class FullPicture extends StatelessWidget {
  String imagePath;

  FullPicture(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Pictures"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: InkWell(
              child: Icon(Icons.file_download),
              onTap: () async {
                try {
                  var imageId = await ImageDownloader.downloadImage(
                      "https://samashti.co.in/" + imagePath);
                  if (imageId == null) {
                    return;
                  }
                  var fileName = await ImageDownloader.findName(imageId);
                } on Exception catch (error) {
                  print(error);
                }
              },
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: PhotoView(
              imageProvider: NetworkImage("" + imagePath),
            ),
        ),
      ),
    );
  }
}
