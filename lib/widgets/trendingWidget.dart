import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/anime.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrendingAnime extends StatefulWidget {
  @override
  State<TrendingAnime> createState() => _TrendingAnimeState();
}

class _TrendingAnimeState extends State<TrendingAnime> {
  List<Anime> _trendingAnimes = <Anime>[];

  @override
  void initState() {
    super.initState();
    _fetchTrendingAnimes();
  }

  Future<void> _fetchTrendingAnimes() async {
    final response =
        await http.get("https://api.consumet.org/meta/anilist/trending");
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;
      setState(() {
        _trendingAnimes = list.map((anime) => Anime.fromJson(anime)).toList();
      });
    } else {
      throw Exception("Could not load trending anime");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
        ),
        items: List.generate(_trendingAnimes.length, (index) {
          final anime = _trendingAnimes[index];
          return Container(
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    child: Image.network(anime.image),
                    borderRadius: BorderRadius.circular(15)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(anime.title),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
