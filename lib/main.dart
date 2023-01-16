import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/movie.dart';
import 'package:postreamv3/widgets/moviesWidget.dart';
import 'package:postreamv3/widgets/video_items.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  List<Movie> _movies = <Movie>[];

  @override
  void initState() {
    super.initState();
    _populateMovies();
    print(_movies);
  }

  void _populateMovies() async {
    final movies = await _fetchMovies();
    setState(() {
      _movies = movies;
    });
  }

  Future<List<Movie>> _fetchMovies() async {
    final response =
        await http.get("https://api.consumet.org/anime/zoro/naruto");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Kan de films niet laden!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Postream',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Search movie'),
            actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
          ),
          body: MoviesWidget(movies: _movies),
        ));
  }
} 

/*void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoStreamv3',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: ChewieVideoItem(videoPlayerController: VideoPlayerController.network('https://c-an-ca6.betterstream.cc:2223/hls-playback/bcc52d54faa312a4db378d17489cb8a004d0e466d2734810803aa4ceb961f23f284642f711fba4bbca93d3ce1f4a812aa5007072775b556dbe37334ab3560bb9f9d4e478a767706fd555769c63ea20b04a3ae13770a01a3892441f884e931f7ff14f3dc79aea06b2e19ee1d694054337ac725a27399185b993973f71aa5fa324e16eca084b91efbda602b271f220b083/index-f1-v1-a1.m3u8'), 
      looping: true),
    );
  }
} */

