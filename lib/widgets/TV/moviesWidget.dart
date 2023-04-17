import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/TVepisodePage.dart';
import 'package:postreamv3/episodePage.dart';
import 'package:postreamv3/main.dart';
import 'package:postreamv3/movieEpisodePage.dart';
import '../../models/movie.dart';

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
                    builder: movie.type == "Movie" ? (context) => movieEpisodePage(id: movie.id.toString(), image: movie.image, type: 'Movie'): (context) => TvEpisodePage(id: movie.id.toString(), image: movie.image, type: 'tv')
                    ),
              );
            },
            title: Row(children: [
              SizedBox(
                width: 200,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(movie.image)),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(movie.title, style: TextStyle(color: Colors.white),)],
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
