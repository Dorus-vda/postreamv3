class MovieEpisode {
  String id;
  String title;
  String image;
  String description;
  String url; 

  //String type;

  MovieEpisode({required this.id, required this.title, required this.image, required this.description, required this.url});

  factory MovieEpisode.fromJson(Map<String, dynamic> json) {
    return MovieEpisode(id: json["id"], title: json["title"] ?? 'no title available', image: json["img"]['mobile'] , description: json["description"] ?? '', url: json['url']);
    //type: json["type"]);
  }

}
