class Movie {
  String id;
  String image;
  String title;
  //String type;

  Movie({required this.id, required this.image, required this.title});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(id: json["id"], image: json["image"], title: json["title"]);
    //type: json["type"]);
  }
}
