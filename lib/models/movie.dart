import 'package:flutter/rendering.dart';

class Movie {
  int id;
  String title;
  String image;
  String description;
  String type;

  Movie({required this.id, required this.title, required this.image, required this.type, required this.description});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(id: json["id"], title: json["title"] ?? 'no title available', image: json["image"] ?? '', type: json['type'] ?? '', description: json["description"]);
  }
}