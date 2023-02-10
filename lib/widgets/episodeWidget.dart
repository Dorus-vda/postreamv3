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
            title: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                width: MediaQuery.of(context).size.width - 50,
                child: Row(
                  children: [Padding(padding: EdgeInsets.only(left: 0), child: SizedBox(child: Image.network(episode.image), width: 150,)), Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(child: Text(episode.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), width: 200,),
                  )],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                child: SizedBox(child: Text(episode.description, style: TextStyle(color: Colors.white, fontSize: 13),), width: MediaQuery.of(context).size.width,),
              )
            ]),
          ),
        );
      },
    );
  }
}
