import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/widgets/video_items.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer(
      {super.key, required this.id, required this.image, required this.title});
  final String id;
  final String image;
  final String title;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController? betterPlayerController;
  String link = '';

  @override
  void initState() {
    super.initState();
    getLink();
  }

  Future getLink() async {
    String templink = await getEpisodeId();
    setState(() {
      link = templink;
      betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(autoPlay: true, autoDetectFullscreenAspectRatio: true, fullScreenByDefault: true),
      betterPlayerDataSource: BetterPlayerDataSource.network(
        link,
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: widget.title,
          imageUrl: widget.image,
        ),
      ),
    );

    betterPlayerController?.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        betterPlayerController?.setOverriddenAspectRatio(
            betterPlayerController!.videoPlayerController!.value.aspectRatio);
        setState(() {});
      }
    });
    });
  }

  Future<String> getEpisodeId() async {
    final response = await http.get(Uri.parse(
        'https://api.consumet.org/movies/flixhq/info?id=${widget.id}'));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> episodes = body['episodes'];
      Map<String, dynamic> singleEpisode = episodes[0];
      //print(singleEpisode['id']);
      String episodeId = singleEpisode['id'];
      print(episodeId);
      final response2 = await http.get(Uri.parse(
          'https://api.consumet.org/movies/flixhq/watch?mediaId=${widget.id}&episodeId=$episodeId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> body2 = json.decode(response2.body);
        List<dynamic> sources = body2['sources'];
        Map<String, dynamic> streaminglink = sources[0];
        print(streaminglink['url']);
        return streaminglink['url'];
      } else {
        throw Exception('Kan Films niet laden!');
      }
    } else {
      throw Exception('Kan Films niet laden!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code
    if (link != '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
        ),
        body: Center(child: BetterPlayer(controller: betterPlayerController!))
        );
    } else {
        return Scaffold(
            body: Center(child: CircularProgressIndicator()),
        );
    }
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