import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/main.dart';
import 'package:postreamv3/models/episode.dart';
import 'package:postreamv3/models/movieEpisode.dart';
import 'package:postreamv3/widgets/better_player.dart';
import 'videoPlayer.dart' as videoPlayer;
import '../models/movie.dart';

class movieEpisodeWidget extends StatelessWidget {
  final List<MovieEpisode> episodes;
  final String title;
  final String movieId;
  final String cover;
  final String episodeId;

  movieEpisodeWidget(
      {required this.episodes, required this.movieId, required this.cover, required this.episodeId, required this.title});

  @override
  Widget build(BuildContext context) {
        return GestureDetector(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => better_player(
                          title: title,
                          cover: cover,
                          episodeId: episodeId,
                          movieId: movieId,
                          isAnime: false,
                        )),
              );
            },
            title: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                width: MediaQuery.of(context).size.width - 50,
                child: Row(
                  children: [Padding(padding: EdgeInsets.only(left: 0), child: SizedBox(child: Image.network(cover), width: 150,)), Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(child: Text('FULL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), width: 200,),
                  )],
                ),
              ),
            ]),
          ),
        );
      }
  }
