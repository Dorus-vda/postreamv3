import 'package:flutter/material.dart';
import 'package:postreamv3/episodePage.dart';
import 'package:postreamv3/models/anime.dart';

class AnimeWidget extends StatefulWidget {
  final List<Anime> animes;

  AnimeWidget({required this.animes});

  @override
  State<AnimeWidget> createState() => _AnimeWidgetState();
}

class _AnimeWidgetState extends State<AnimeWidget> {
  List<Anime> filteredAnimes = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        children: [
          // Remove the TextField widget for search bar
          Expanded(
            child: ListView.builder(
              itemCount: filteredAnimes.length > 0
                  ? filteredAnimes.length
                  : widget.animes.length,
              itemBuilder: (context, index) {
                final anime = filteredAnimes.length > 0
                    ? filteredAnimes[index]
                    : widget.animes[index];

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
                            children: [
                              // Make sure that anime.title is not null or empty before passing it to Text widget
                              Text(
                                anime.title ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
