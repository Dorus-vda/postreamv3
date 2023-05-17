import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/RecentWatch/recentWatchManager.dart';
import 'package:postreamv3/models/episode.dart';
import 'package:postreamv3/models/movie.dart';
import 'package:postreamv3/noScrollGlow.dart';
import 'package:postreamv3/widgets/episodeWidget.dart';
import 'package:postreamv3/widgets/video_items.dart';

import 'RecentWatch/recentAnime';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key, required this.id, required this.image});
  final String id;
  final String image;

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  List<Episode> _episodes = <Episode>[];
  String image = '';
  String title = '';
  String descr = '';
  late List<RecentAnime> _recentEpisodeList;
  int recentAnimeIndex = 0;

  @override
  void initState() {
    super.initState();
    _populateMovies();
  }

  void _populateMovies() async {
    final episodes = await _fetchEpisodes();
    final recentEpisodeList = await RecentWatchManager().loadRecentAnimeFromDatabase();
    setState(() {
      for(var an in recentEpisodeList){
        if(an.id == widget.id){
          recentAnimeIndex = int.parse(an.currentEp);
          break;
        }
      }
      _episodes = episodes;
    });
  }

  Future<List<Episode>> _fetchEpisodes() async {
    final response = await http
        .get(Uri.parse("https://api.consumet.org/meta/anilist/info/${widget.id}"));
    //await http.get("http://api.consumet.org/anime/gogoanime/$search_title");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      image = result["image"];
      title = result["title"]['english'] ?? "no title available";
      descr = result["description"];
      descr = descr.replaceAll(RegExp('\\<.*?\\>'), '');
      Iterable list = result["episodes"];
      return list.map((episode) => Episode.fromJson(episode)).toList();
    } else {
      throw Exception("Kan de films niet laden!");
    }
  }

  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (image != '') {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Postream',
          home: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 38, 38, 38),
              title: const Text("Episodes"),
            ),
            body: Container(
              child: ScrollConfiguration(
                behavior: noScrollGlow(),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: CachedNetworkImage(imageUrl: widget.image),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, bottom: 12),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 166,
                                  height: 200,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      descr,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      child: EpisodesWidget(
                        recentEpisode: recentAnimeIndex,
                        cover: image,
                        episodes: _episodes,
                        movieId: widget.id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    } else {
      return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.black)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
