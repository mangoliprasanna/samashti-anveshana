class Feed {
  String feed_img, feed_date, feed_caption, feed_by, feed_isLiked, likes, comment, id, action;
  Feed(var json){
    this.feed_caption = json["feed_caption"];
    this.action = json["feed_action"];
    this.id = json["id"];
    this.feed_img = json["feed_image"];
    this.likes = json["likes"];
    this.comment = json["comment"];
    this.feed_by = json["feed_by"];
    this.feed_date = json["feed_created"];
  }  
}