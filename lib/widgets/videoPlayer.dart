import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/widgets/video_items.dart';
import 'package:postreamv3/sources/flixhq.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer(
      {super.key, required this.episodeId, required this.movieId});
  final String episodeId;
  final String movieId;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController? betterPlayerController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String link = '';
  String referer = '';

  @override
  void initState() {
    getLink();
    super.initState();
  }

  Future getLink() async {
    String templink = await flixhq(id: widget.episodeId, movieId: widget.movieId).getEpisodeId();
    setState(() {
      link = templink;

      _videoPlayerController = VideoPlayerController.network(link);

      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          fullScreenByDefault: true,
          allowFullScreen: true,
          autoInitialize: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (link != '') {
      return MaterialApp(
        home: Scaffold(backgroundColor: Colors.black,
          body: Center(child: Chewie(controller: _chewieController!)),
      ));
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}




/*late String id = widget.id;
  String link = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      getLink();
    });
  }

  getLink() async {
    await getEpisodeId();
    print(link);
  }

  getEpisodeId() async {
    final response =
        await http.get('https://api.consumet.org/anime/zoro/info?id=$id');
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> episodes = map['episodes'];
    Map<String, dynamic> episodeNumber = episodes[0];
    final episodeid = episodeNumber['id'];

    final response2 = await http
        .get('https://api.consumet.org/anime/zoro/watch?episodeId=$episodeid');
    Map<String, dynamic> map2 = json.decode(response2.body);
    List<dynamic> sources = map2['sources'];
    Map<String, dynamic> streamingurls = sources[0];
    String url = streamingurls['url'];
    link = url;
  } */
