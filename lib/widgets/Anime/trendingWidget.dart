import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/anime.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:postreamv3/RecentWatch/recentAnime';
import 'package:postreamv3/RecentWatch/recentWatchManager.dart';


import '../../episodePage.dart';


class TrendingAnime extends StatefulWidget {
  final String keyword;

  TrendingAnime({required this.keyword});

  @override
  State<TrendingAnime> createState() => trendingAnimeListtate();
}

class trendingAnimeListtate extends State<TrendingAnime> {
  List<Anime> trendingAnimeList = <Anime>[];

  @override
  void initState() {
    super.initState();
    _fetchTrendingAnimes();
  }

  Future<void> _fetchTrendingAnimes() async {
    final response =
        await http.get(Uri.parse("https://api.consumet.org/meta/anilist/${widget.keyword}"));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      setState(() {
        trendingAnimeList = list.map((anime) => Anime.fromJson(anime)).toList();
      });
    } else {
      throw Exception("Could not load trending anime");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: trendingAnimeList.length,
      itemBuilder: (context, index) {
        final anime = trendingAnimeList[index];
        if (anime.title != null && anime.image != null){
          return GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EpisodePage(id: anime.id, image: anime.image)),
              );
              final recentAnime = RecentAnime(currentEp: '2', epUrl: 'shingeki-no-kyojin-episode-2', id: anime.id, name: anime.title, imageUrl: anime.image);
              RecentWatchManager().addAnimeToRecent(recentAnime, await RecentWatchManager().loadRecentAnimeFromDatabase());
              print("TAPPED");
            },
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              key: UniqueKey(),
              width: 150,
              height: 200,
              child: ListTile(
                title: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(imageUrl: anime.image, progressIndicatorBuilder: (context, url, progress) => SizedBox(child: Center(child: CircularProgressIndicator(color: Colors.white)), height: 20,),),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Container(
                          child: Text(
                            anime.title,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
