class Episode {
  String id;
  String title;
  String image;
  //String type;

  Episode({required this.id, required this.title, required this.image});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(id: json["id"], title: json["title"], image: json["image"]);
    //type: json["type"]);
  }
}
