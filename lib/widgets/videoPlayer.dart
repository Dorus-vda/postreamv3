import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:postreamv3/aidancontrols.dart';
import 'package:postreamv3/main.dart';
import 'package:postreamv3/sources/anilist.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/widgets/video_items.dart';
import 'package:postreamv3/sources/flixhq.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


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
  WebViewController? controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    NowPlaying.instance.start();
    getLink();
    super.initState();
  }

  Future getLink() async {
    String templink =
        await anilist(id: widget.episodeId, movieId: widget.movieId)
            .getEpisodeId(); 
    setState(() {
      link = templink;

      /*_videoPlayerController = VideoPlayerController.network('https://wwwx14.gofcdn.com/videos/hls/AwBdJgRWstkl8XCo0tuPKw/1675084599/2633/4f762bd70a47a42d9d61cc4816e19295/ep.1.1657688609.720.m3u8');


      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        fullScreenByDefault: true,
        allowFullScreen: true,
        autoPlay: true,
        autoInitialize: true,
        customControls: CustomPlayerControls(
            backgroundColor: Colors.transparent, iconColor: Colors.white),
      ); */
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
  ..loadRequest(Uri.parse(link));
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          Navigator.of(context).userGestureInProgress ? false : true,
      child: Builder(builder: (context) {
        if (controller != null) {
          return SafeArea(
              child: Scaffold(
            backgroundColor: Colors.black,
            //body: Chewie(controller: _chewieController!),
            body: WebViewWidget(controller: controller!),
          ));
        }
        return const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Colors.black), backgroundColor: Colors.white,));
      }),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
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
