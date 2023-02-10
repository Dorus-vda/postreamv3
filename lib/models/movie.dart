class Movie {
  int id;
  String image;
  String title;
  String type;

  Movie({required this.id, required this.image, required this.title, required this.type});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(id: json["id"], image: json["image"], title: json["title"], type: json["type"]);
  }
}
