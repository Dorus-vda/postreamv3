/*import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/models/movie.dart';
import 'package:postreamv3/widgets/moviesWidget.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoItem extends StatefulWidget {
  final String url;
  final bool looping;

  ChewieVideoItem({
    required this.url,
    required this.looping,
  });

  @override
  State<ChewieVideoItem> createState() => _ChewieVideoItemState();
}

class _ChewieVideoItemState extends State<ChewieVideoItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    //Wrapper on top of the videoPlayerController
    _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.network(widget.url),
        autoInitialize: true,
        aspectRatio: 16/9,
        autoPlay: true,
        fullScreenByDefault: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.green),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chewieController.dispose();
  }
}*/
