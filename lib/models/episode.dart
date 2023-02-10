class Episode {
  String id;
  String title;
  String image;
  String description;
  //String type;

  Episode({required this.id, required this.title, required this.image, required this.description});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(id: json["id"], title: json["title"], image: json["image"], description: json["description"]);
    //type: json["type"]);
  }
}
