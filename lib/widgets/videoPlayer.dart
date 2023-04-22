import 'dart:convert';
import 'package:better_player/better_player.dart';
//import 'package:flick_video_player/flick_video_player.dart';
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

class VideoPlayer extends StatefulWidget {
  const VideoPlayer(
      {super.key,
      required this.episodeId,
      required this.movieId,
      required this.isAnime});
  final String episodeId;
  final String movieId;
  final bool isAnime;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  //late FlickManager flickManager;
  VideoPlayerController? _videoPlayerController;
  BetterPlayerController? _betterPlayerController;
  WebViewController? controller;
  String link = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
    getLink();
    super.initState();
  }

  Future getLink() async {
    String templink = '';
    String tvUrl = '';
    templink = await anilist(id: widget.episodeId, movieId: widget.movieId)
        .getEpisodeId();
    link = templink;
    /* setState(() {
      link = templink;
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(templink));
    }); */
    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, templink);
    setState(() {
      _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: false,
            progressBarPlayedColor: Colors.red,
            progressBarBufferedColor: Colors.grey,
            progressBarBackgroundColor: Colors.black,
            enableQualities: false,
            playerTheme: BetterPlayerTheme.material,
          ),
          fit: BoxFit.contain,
          autoDispose: true,
          autoPlay: true,
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_betterPlayerController != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: BetterPlayer(
          controller: _betterPlayerController!,
        ),
      );
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
    _videoPlayerController?.dispose();
    //flickManager.dispose();
    _betterPlayerController!.dispose();
    _betterPlayerController = null;
    link = '';
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
