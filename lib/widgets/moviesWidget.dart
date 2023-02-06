import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/episodePage.dart';
import '../widgets/videoPlayer.dart' as videoPlayer;
import '../models/movie.dart';

class MoviesWidget extends StatefulWidget {
  final List<Movie> movies;

  MoviesWidget({required this.movies});

  @override
  State<MoviesWidget> createState() => _MoviesWidgetState();
}

class _MoviesWidgetState extends State<MoviesWidget> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        final movie = widget.movies[index];

        return GestureDetector(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EpisodePage(id: movie.id)),
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
