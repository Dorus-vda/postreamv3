import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/main.dart';
import 'package:postreamv3/models/episode.dart';
import '../widgets/videoPlayer.dart' as videoPlayer;
import '../models/movie.dart';

class EpisodesWidget extends StatelessWidget {
  final List<Episode> episodes;
  final String movieId;
  final String cover;

  EpisodesWidget(
      {required this.episodes, required this.movieId, required this.cover});

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
                    builder: (context) => videoPlayer.VideoPlayer(
                          episodeId: episode.id,
                          movieId: movieId,
                        )),
              );
            },
            title: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(episode.image),
                          fit: BoxFit.fitWidth,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.darken))),
                  width: 300,
                  height: 100,
                  child: Text(episode.title),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
