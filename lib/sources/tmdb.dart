import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/widgets/video_items.dart';

class tmdb {
  String id;
  String movieId;

  tmdb({required this.id, required this.movieId});

  Future<List> getEpisodeId() async {
    String? en_subtitle;
    String? nl_subtitle;
    
    final response2 = await http.get(Uri.parse(
        'https://consumet-api-yeqo.onrender.com/meta/tmdb/watch/$id?id=${movieId}'));
    if (response2.statusCode == 200) {
      Map<String, dynamic> body2 = json.decode(response2.body);
      List<dynamic> sources = body2['sources'];
      Map<String, dynamic> streaminglink = sources[0];

      for (Map<String, dynamic> subtitle in body2['subtitles']) {
        if (subtitle['lang'] == "English") {
          en_subtitle = subtitle['url'];
        }
      }

      for (Map<String, dynamic> subtitle in body2['subtitles']) {
        if (subtitle['lang'] == "Dutch") {
          nl_subtitle = subtitle['url'];
        }
      }
      //Map<String, dynamic> header = body2['headers'];
      // print(header['Referer']);
      //referer = header['Referer'];
      print(streaminglink['url']);
      return [streaminglink['url'], en_subtitle, nl_subtitle];
    } else {
      throw Exception('Kan Films niet laden!');
    }
  }
}
