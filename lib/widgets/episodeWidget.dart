import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/episode.dart';
import '../widgets/videoPlayer.dart' as videoPlayer;
import '../models/movie.dart';

class EpisodesWidget extends StatelessWidget {
  final List<Episode> episodes;
  final String movieId;

  EpisodesWidget({required this.episodes, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];

        return GestureDetector(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => videoPlayer.VideoPlayer(episodeId: episode.id, movieId: movieId,)),
              );
            },
            title: Row(children: [
              SizedBox(
                width: 300,
                height: 100,
                child: ClipRRect(
                    child: Text(episode.title),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ]),
          ),
        );
      },
    );
  }
}
