class Sellers {
  String? email;
  String? name;
  String? phone;
  String? ratings;
  String? photoUrl;
  String? uid;

  Sellers(this.email, this.name, this.phone, this.ratings, this.photoUrl, this.uid);

  Sellers.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    name = json["name"];
    phone = json["phone"];
    ratings = json["ratings"];
    photoUrl = json["photoUrl"];
    uid = json["uid"];
  }
}
