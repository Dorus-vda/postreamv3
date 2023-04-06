import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/anime.dart';
import 'package:postreamv3/widgets/animeWidget.dart';
import 'package:postreamv3/widgets/searchWidget.dart';
import 'package:postreamv3/widgets/trendingWidget.dart';

class animeHomePage extends StatefulWidget {
  const animeHomePage({Key? key}) : super(key: key);

  @override
  State<animeHomePage> createState() => _AnimeHomePageState();
}

class _AnimeHomePageState extends State<animeHomePage> {
  List<Anime> _animes = <Anime>[];
  String searchTitle = "naruto";

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)));

  @override
  void initState() {
    super.initState();
    _populateAnimes();
  }

  void _populateAnimes() async {
    final animes = await _fetchAnimes();
    setState(() {
      _animes = animes;
    });
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
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 38, 38, 38),
          title: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter a title',
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _searchAnimes();
              },
            ),
          ],
        ),
        body: Column(
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
              height: 200,
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
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
