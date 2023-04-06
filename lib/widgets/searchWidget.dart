import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/episodePage.dart';
import 'package:postreamv3/models/anime.dart';
import '../models/movie.dart';

class searchWidget extends StatefulWidget {
  final List<Anime> animes;

  searchWidget({required this.animes});

  @override
  State<searchWidget> createState() => _searchWidgetState();
}

class _searchWidgetState extends State<searchWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.animes.length,
      itemBuilder: (context, index) {
        final anime = widget.animes[index];

        return GestureDetector(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EpisodePage(id: anime.id, image: anime.image)),
              );
            },
            title: Row(children: [
              SizedBox(
                width: 200,
                child: ClipRRect(
                    child: Image.network(anime.image),
                    borderRadius: BorderRadius.circular(15)),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(anime.title)],
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
