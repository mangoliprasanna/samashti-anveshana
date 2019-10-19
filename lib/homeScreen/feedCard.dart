import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:samashti_app/model/feed.dart';

class FeedCard extends StatefulWidget {
  final Feed currentFeed;
  final String chest_no;
  FeedCard(this.currentFeed, this.chest_no);
  _FeedCardState createState() => _FeedCardState(this.currentFeed, this.chest_no);
}

class _FeedCardState extends State<FeedCard> {
  final Feed currentFeed;
  final String chest_no;
  _FeedCardState(this.currentFeed, this.chest_no);
  bool isTrue = true;
  int likeCount = 0;
  int commentCount = 0;
  Widget videoOrImage;

  @override
  void initState() {
    super.initState();

    videoOrImage =  FadeInImage(
              image: NetworkImage(
                  "https://samashti.co.in/" + currentFeed.feed_img),
              placeholder: AssetImage("assets/l_logo.png"),
            );  
  }

  @override
  Widget build(BuildContext context) {
    likeCount = int.parse(currentFeed.likes.toString());
    final likedButton = FlatButton(
      onPressed: () {
        setState(() {
          
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            color: Theme.of(context).accentColor,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Text(
              "Like",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          )
        ],
      ),
    );

    final likeButton = FlatButton(
      onPressed: () {
        if(this.chest_no != ""){
          String path = "https://samashti.co.in/api/v3/feeds/like_feed.php?feed_id=" + currentFeed.id + "&chest_id=" + this.chest_no.toString();
          http.get(path).then((http.Response response) {
             Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("You liked this post."),
                duration: Duration(seconds: 3),
              ));
              setState(() {
                currentFeed.likes = (int.parse(currentFeed.likes) + 1).toString();
                isTrue = false;
              });
          }); 
        }
      },
      child: (this.chest_no != "") ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.thumb_up,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Text(
              "Like",
            ),
          )
        ],
      ) : Text("Login to like"),
    );

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      currentFeed.feed_by,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Text(
                      DateFormat("dd MMM, hh:mm a").format(
                          DateFormat("yyyy-MM-dd HH:mm:ss")
                              .parse(currentFeed.feed_date)),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ]),
            ),
           videoOrImage,
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                currentFeed.feed_caption,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    likeCount.toString() + " Likes ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.4,
              color: Colors.grey,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: (isTrue) ? likeButton : likedButton),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
