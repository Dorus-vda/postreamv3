import 'dart:convert';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:postreamv3/aidancontrols.dart';
import 'package:postreamv3/main.dart';
import 'package:postreamv3/sources/anilist.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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
  late FlickManager flickManager;
  late SubtitleController subtitleController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  WebViewController? controller;
  String link = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
    NowPlaying.instance.start();
    getLink();
    super.initState();
  }

  Future getLink() async {
    String templink = '';
    String tvUrl = '';
    if (widget.isAnime == true) {
      templink = await anilist(id: widget.episodeId, movieId: widget.movieId)
          .getEpisodeId();
      setState(() {
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
      });
    } else {
      subtitleController = SubtitleController(
          subtitleUrl:
              "https://cc.2cdns.com/00/20/0020572b586f282773d0f5d7447415f5/dut-16.vtt", //	supports  webvtt or srt.
          subtitleType: SubtitleType.webvtt,
          subtitleDecoder: SubtitleDecoder.utf8,
          showSubtitles: true);
      tvUrl = await tmdb(id: widget.episodeId, movieId: widget.movieId)
          .getEpisodeId();
      setState(() {
        link = tvUrl;
        flickManager = FlickManager(
          autoInitialize: true,
          videoPlayerController: VideoPlayerController.network(tvUrl),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (link != '' && widget.isAnime == true) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: WebViewWidget(controller: controller!),
        ),
      );
    } else if (flickManager != null && widget.isAnime != true) {
      flickManager.flickControlManager!.enterFullscreen();
      return Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          preferredDeviceOrientation: [
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft
          ],
          systemUIOverlay: [],
          flickVideoWithControls: SubtitleWrapper(
            videoPlayerController: flickManager.flickVideoManager!.videoPlayerController!,
            subtitleController: subtitleController,
            subtitleStyle: SubtitleStyle(
              textColor: Colors.white,
              fontSize: 16.0,
              hasBorder: true,
            ),
            videoChild: FlickVideoWithControls(
              videoFit: BoxFit.fitWidth,
              controls: FlickLandscapeControls(),
            ),
          ),
        ),
      ); //Center(child: Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,child: AspectRatio(aspectRatio: 16/9,child: Chewie(controller: _chewieController!)))),
    }
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    flickManager.dispose();
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
