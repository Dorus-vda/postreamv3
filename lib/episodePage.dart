import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/episode.dart';
import 'package:postreamv3/models/movie.dart';
import 'package:postreamv3/widgets/moviesWidget.dart';
import 'package:postreamv3/widgets/episodeWidget.dart';
import 'package:postreamv3/widgets/video_items.dart';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key, required this.id});
  final String id;

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  List<Episode> _episodes = <Episode>[];
  String cover = '';

  @override
  void initState() {
    super.initState();
    _populateMovies();
  }

  void _populateMovies() async {
    final episodes = await _fetchEpisodes();
    setState(() {
      _episodes = episodes;
    });
  }

  Future<List<Episode>> _fetchEpisodes() async {
    final response = await http
      .get("https://api.consumet.org/meta/anilist/info/${widget.id}");
    //await http.get("http://api.consumet.org/anime/gogoanime/$search_title");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      cover = result["cover"];
      Iterable list = result["episodes"];
      return list.map((episode) => Episode.fromJson(episode)).toList();
    } else {
      throw Exception("Kan de films niet laden!");
    }
  }

  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (cover != '') {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Postream',
          home: Scaffold(
            appBar: AppBar(title: Text("Episodes"),),
            body: EpisodesWidget(
              cover: cover,
              episodes: _episodes,
              movieId: widget.id,
            ),
          ));
    } else {
      return Scaffold(body: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Colors.black), backgroundColor: Colors.white)));
    }
  }
}
