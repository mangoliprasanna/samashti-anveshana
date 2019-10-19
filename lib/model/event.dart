class Event {
  String event_id, event_name, event_start, event_desc, event_categoryName, event_contact, event_person, event_image, event_token;
  Event(var json){
    this.event_id = json["id"];
    this.event_name = json["event_name"];
    this.event_start = json["event_start"];
    this.event_desc = json["event_desc"];
    this.event_categoryName = json["category_name"];
    this.event_contact = json["event_contact"];
    this.event_person = json["event_person"];
    this.event_image = json["event_image"];
    this.event_token = json["event_token"];
  }
}