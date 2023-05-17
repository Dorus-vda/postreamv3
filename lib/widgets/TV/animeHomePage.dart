import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/RecentWatch/recentShow.dart';
import 'package:postreamv3/RecentWatch/recentWatchManager.dart';
import 'package:postreamv3/models/anime.dart';
import 'package:postreamv3/widgets/Anime/animeWidget.dart';
import 'package:postreamv3/widgets/searchWidget.dart';
import 'package:postreamv3/widgets/Anime/trendingWidget.dart';

import '../../RecentWatch/recentAnime';
import '../../episodePage.dart';
import '../videoPlayer.dart';

class animeHomePage extends StatefulWidget {
  const animeHomePage({Key? key}) : super(key: key);

  @override
  State<animeHomePage> createState() => _AnimeHomePageState();
}

class _AnimeHomePageState extends State<animeHomePage> {
  List<Anime> _animes = <Anime>[];
  String searchTitle = "naruto";
  List<RecentAnime> animeList = <RecentAnime>[];

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)));

  @override
  void initState() {
    super.initState();
    loadAnimeDatabase();
  }

  void loadAnimeDatabase() async {
    animeList = await RecentWatchManager().loadRecentAnimeFromDatabase();
    setState(() {});
  }

  Future<List<Anime>> _fetchAnimes() async {
    final response = await http
        .get(Uri.parse("https://api.consumet.org/meta/anilist/$searchTitle"));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((anime) => Anime.fromJson(anime)).toList();
    } else {
      throw Exception("Can't load animes!");
    }
  }

  TextEditingController searchController = TextEditingController();

  void _searchAnimes() async {
    searchTitle = searchController.text;
    final animes = await _fetchAnimes();
    setState(() {
      _animes = animes;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimeWidget(animes: _animes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 38, 38, 38),
            title: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Enter a title',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                _searchAnimes();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _searchAnimes();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  child: Text(
                    "Popular",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  child: TrendingAnime(keyword: "popular?&perPage=20"),
                  height: MediaQuery.of(context).size.height / 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  child: Text(
                    "Trending",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  child: TrendingAnime(keyword: "trending?&perPage=20"),
                  height: MediaQuery.of(context).size.height / 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  child: Text(
                    "Recently Watched",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: ValueListenableBuilder(
                      valueListenable: RecentWatchManager().updater,
                      builder: (context, value, child) {
                        loadAnimeDatabase();
                        return ListView.builder(
                          itemCount:
                              animeList.length < 10 ? animeList.length : 10,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final anime = animeList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoPlayer(
                                            episodeId: anime.epUrl,
                                            movieId: anime.id,
                                            isAnime: true,
                                          )),
                                );
                                HapticFeedback.lightImpact();
                              },
                              onLongPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EpisodePage(
                                          id: anime.id, image: anime.imageUrl)),
                                );
                                HapticFeedback.mediumImpact();
                              },
                              child: Container(
                                key: UniqueKey(),
                                width: 150,
                                height: MediaQuery.of(context).size.height / 5,
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.network(
                                            anime.imageUrl,
                                            scale: 0.2,
                                            filterQuality: FilterQuality.none,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Container(
                                            child: Text(
                                              "Episode: ${(int.parse(anime.currentEp) - 1)}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
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
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}
