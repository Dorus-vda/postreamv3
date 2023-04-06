import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:postreamv3/models/movie.dart';
import 'package:postreamv3/widgets/TV/animeHomePage.dart';
import 'customIcons/my_flutter_app_icons.dart' as CustomIcons;
import 'package:postreamv3/widgets/videoPlayer.dart';
import 'package:postreamv3/widgets/video_items.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'widgets/TV/movieHomePage.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  int _selectedIndex = 0;
  TextEditingController searchcontroller = TextEditingController();
  int _selectedPage = 0;
  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    pageList.add(animeHomePage());
    pageList.add(movieHomePage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor:Color.fromARGB(255, 38, 38, 38)),
      debugShowCheckedModeBanner: false,
      title: 'Postream',
      home: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Color.fromARGB(255, 38, 38, 38),
          curve: Curves.fastLinearToSlowEaseIn,
          selectedIndex: _selectedIndex,
          onItemSelected: (clickedIndex) {
            setState(() {
              _selectedIndex = clickedIndex;
            });
          },
          items: [
            BottomNavyBarItem(
                title: Text("Anime"),
                icon: Icon(CustomIcons.MyFlutterApp.kanji),
                activeColor: Colors.red),
            BottomNavyBarItem(
                title: Text("TV"),
                icon: Icon(Icons.tv_rounded),
                activeColor: Colors.blue)
          ],
        ),
      ),
    );
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

