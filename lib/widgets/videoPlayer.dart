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

  @override
  void initState() {
    betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(aspectRatio: 16 / 9),
      betterPlayerDataSource: BetterPlayerDataSource.network(
        'https://wwwx11.gofcdn.com/videos/hls/c6TDKi-ep6awviV-bHKAdg/1673927019/71300/a1838868c6ce2b8f60f11d90af7035e8/ep.1.1657688511.1080.m3u8',
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(controller: betterPlayerController!),
      ),
    );
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
