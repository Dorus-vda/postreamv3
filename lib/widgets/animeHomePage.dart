import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:postreamv3/models/anime.dart';
import 'package:postreamv3/widgets/animeWidget.dart';
import '../models/movie.dart';
import 'moviesWidget.dart';

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
    _populateMovies();
  }

  void _populateMovies() async {
    final animes = await _fetchMovies();
    setState(() {
      _animes = animes;
    });
  }

  Future<List<Anime>> _fetchMovies() async {
    final response = await http.get(Uri.encodeFull(
            "http://api.consumet.org/meta/anilist/$search_title"));
        

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
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
        debugShowCheckedModeBanner: false,
        title: 'Postream',
        home: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: TextField(
              controller: searchcontroller,
              decoration: const InputDecoration(
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(color: Colors.white)),
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    search_title = searchcontroller.text;
                    _populateMovies();
                  })
            ],
          ),
          body: animeWidget(animes: _animes),
        )
    );
  }
}