import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:postreamv3/aidancontrols.dart';
import 'package:postreamv3/main.dart';
import 'package:postreamv3/sources/anilist.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/widgets/video_items.dart';
import 'package:postreamv3/sources/tmdb.dart';
import 'package:webview_flutter/webview_flutter.dart';

class better_player extends StatefulWidget {
  const better_player(
      {super.key,
      required this.title,
      required this.cover,
      required this.episodeId,
      required this.movieId,
      required this.isAnime});
  final String title;
  final String cover;
  final String episodeId;
  final String movieId;
  final bool isAnime;

  @override
  State<better_player> createState() => _better_playerState();
}

class _better_playerState extends State<better_player> {
  BetterPlayerController? _betterPlayerController;
  String? streamlink;
  String? en_subtitleURL;
  String? nl_subtitleURL;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
    initBetterPlayer();
    super.initState();
  }

  void initBetterPlayer() async {
    streamlink = await getUrl();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, streamlink!,
        subtitles: [
          BetterPlayerSubtitlesSource(
          name: "NL",
          selectedByDefault: true,
          type: BetterPlayerSubtitlesSourceType.network,
          urls: [nl_subtitleURL]
        ),
          BetterPlayerSubtitlesSource(
          name: "EN",
          selectedByDefault: true,
          type: BetterPlayerSubtitlesSourceType.network,
          urls: [en_subtitleURL]
        ),],
        notificationConfiguration: BetterPlayerNotificationConfiguration(
            showNotification: true, title: widget.title, imageUrl: widget.cover, activityName: "postreamV3"));
    setState(() {
      _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
              fit: BoxFit.contain,
              autoDetectFullscreenAspectRatio: true,
              subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
                fontSize: 25,
                backgroundColor: Colors.black38,
              ),
              autoDispose: true,
              autoPlay: true),
          betterPlayerDataSource: betterPlayerDataSource);
    });
  }

  Future<String> getUrl() async {
    List episodeData = await tmdb(id: widget.episodeId, movieId: widget.movieId)
        .getEpisodeId();
    String url = episodeData[0];

    if (episodeData[1] != null)
      en_subtitleURL = episodeData[1];
    
    if (episodeData[2] != null)
      nl_subtitleURL = episodeData[2];

    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (_betterPlayerController != null) {
      return Scaffold(body: BetterPlayer(controller: _betterPlayerController!));
    }
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _betterPlayerController!.dispose();

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
