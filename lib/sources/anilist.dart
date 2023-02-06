import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/widgets/video_items.dart';

class anilist {
  String id;
  String movieId;

  anilist({required this.id, required this.movieId});

  Future<String> getEpisodeId() async {
      final response2 = await http.get(Uri.parse(
          'https://api.consumet.org/meta/anilist/watch/$id'));
      if (response2.statusCode == 200) {
        Map<String, dynamic> body2 = json.decode(response2.body);
        List<dynamic> sources = body2['sources'];
        Map<String, dynamic> streaminglink = sources[3];
        //Map<String, dynamic> header = body2['headers'];
        // print(header['Referer']);
        //referer = header['Referer'];
        print(streaminglink['url']);
        return streaminglink['url'];
      } else {
        throw Exception('Kan Films niet laden!');
      }
    }
  }