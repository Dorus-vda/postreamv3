class Episode {
  String id;
  String title;
  String image;
  String description;
  int number;
  //String type;

  Episode({required this.id, required this.title, required this.image, required this.description, required this.number});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(id: json["id"], title: json["title"] ?? 'no title available', image: json["image"] ?? '', description: json["description"] ?? '', number: json["number"]);
    //type: json["type"]);
  }

}
