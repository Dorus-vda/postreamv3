import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:postreamv3/models/anime.dart';
import 'package:postreamv3/widgets/Anime/trendingWidget.dart';

class animeHomePage extends StatefulWidget {
  const animeHomePage({super.key});

  @override
  State<animeHomePage> createState() => _animeHomePageState();
}

class _animeHomePageState extends State<animeHomePage> {
  List<Anime> _animes = <Anime>[];
  String search_title = "Naruto";

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)));

  @override
  void initState() {
    super.initState();
    _populateAnimes();
  }

  void _populateAnimes() async {
    final animes = await _fetchMovies();
    setState(() {
      _animes = animes;
    });
  }

  Future<List<Anime>> _fetchMovies() async {
    final response = await http.get(Uri.parse("http://api.consumet.org/meta/anilist/$search_title"));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((anime) => Anime.fromJson(anime)).toList();
    } else {
      throw Exception("Kan de films niet laden!");
    }
  }

  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 38, 38, 38),
          title: TextField(
            controller: searchcontroller,
            decoration: const InputDecoration(
                hintText: 'Enter a title',
                hintStyle: TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  search_title = searchcontroller.text;
                  _populateAnimes();
                })
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
              child: Text(
                "Popular",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              child: TrendingAnime(keyword: "trending?&perPage=20"),
              height: 200,
            ),
          ],
        ));
  }
}
