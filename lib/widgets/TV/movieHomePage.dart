import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../models/movie.dart';
import 'moviesWidget.dart';

class movieHomePage extends StatefulWidget {
  const movieHomePage({super.key});

  @override
  State<movieHomePage> createState() => _movieHomePageState();
}

class _movieHomePageState extends State<movieHomePage> {
  List<Movie> _movies = <Movie>[];
  String search_title = "";

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)));

  @override
  void initState() {
    super.initState();
    _populateMovies();
  }

  void _populateMovies() async {
    final movies = await _fetchMovies();
    setState(() {
      _movies = movies;
    });
  }

  Future<List<Movie>> _fetchMovies() async {
    final response =
        await http.get(Uri.parse("https://api.consumet.org/meta/tmdb/$search_title"));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Kan de films niet laden!");
    }
  }

  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        title: TextField(
          controller: searchcontroller,
          decoration: const InputDecoration(
              hintText: 'Enter a title',
              hintStyle: TextStyle(color: Colors.grey)),
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
        body: search_title != "" ? MoviesWidget(movies: _movies) : Center(child: Text("Search for a movie/tv show", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}