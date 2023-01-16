import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/videoPlayer.dart' as videoPlayer;
import '../models/movie.dart';

class MoviesWidget extends StatelessWidget {
  final List<Movie> movies;

  MoviesWidget({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return GestureDetector(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => videoPlayer.VideoPlayer(id: movie.id, title: movie.title, image: movie.image,)),
              );
            },
            title: Row(children: [
              SizedBox(
                width: 200,
                child: ClipRRect(
                    child: Image.network(movie.image),
                    borderRadius: BorderRadius.circular(15)),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(movie.title)],
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
