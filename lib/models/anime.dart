class Anime {
  String id;
  String image;
  String title;
  //String type;

  Anime({required this.id, required this.image, required this.title});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(id: json["id"], image: json["image"], title: json["title"]["romaji"]);
    //type: json["type"]);
  }
}
