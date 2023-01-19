class Episode {
  String id;
  String title;
  //String type;

  Episode({required this.id, required this.title});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(id: json["id"], title: json["title"]);
    //type: json["type"]);
  }
}
