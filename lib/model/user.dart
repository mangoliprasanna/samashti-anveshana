class User {
  String user_name, user_chest, user_year, user_class, user_email, user_gender, user_dob, user_phone, user_device;

  User(var json){
    this.user_name = json["participent_name"];
    this.user_chest = json["participent_chest"];
    this.user_year = json["participent_year"];
    this.user_class = json["participent_class"];
    this.user_email = json["participent_email"];
    this.user_gender = json["participent_gender"];
    this.user_dob = json["participent_dob"];
    this.user_phone = json["participent_phone"];
    this.user_device = json["participent_device"];
  }
}