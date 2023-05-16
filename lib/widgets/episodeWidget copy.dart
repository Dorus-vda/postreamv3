import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/main.dart';
import 'package:postreamv3/models/episode.dart';
import 'package:postreamv3/widgets/videoPlayer.dart';
import '../RecentWatch/recentAnime';
import '../RecentWatch/recentWatchManager.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';

class EpisodesWidget extends StatelessWidget {
  final List<Episode> episodes;
  final String movieId;
  final String cover;
  final int recentEpisode;

  EpisodesWidget(
      {required this.episodes, required this.movieId, required this.cover, required this.recentEpisode});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return GestureDetector(
          child: Container(
            color: index <= recentEpisode-2 ? Colors.grey : Colors.transparent,
            child: ListTile(
              //enabled: index <= recentEpisode ? false : true,
              enableFeedback: true,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                            episodeId: episode.id,
                            movieId: movieId,
                            isAnime: true,
                          )),
                );
                if (index+1 <= episodes.length-1){
                  final nextepisode = episodes[index+1];
                  final nextAnime = RecentAnime(currentEp: nextepisode.number.toString(), epUrl: nextepisode.id, id: movieId, name: nextepisode.title, imageUrl: cover);
                  RecentWatchManager().addAnimeToRecent(nextAnime, await RecentWatchManager().loadRecentAnimeFromDatabase());
                } else{
                  final nextepisode = episodes[index];
                  final nextAnime = RecentAnime(currentEp: (nextepisode.number + 1).toString(), epUrl: nextepisode.id, id: movieId, name: nextepisode.title, imageUrl: cover);
                  RecentWatchManager().addAnimeToRecent(nextAnime, await RecentWatchManager().loadRecentAnimeFromDatabase());
                }
              },
              title: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: SizedBox(
                              height: 90,
                              child: Image.network(episode.image, scale: 0.2, filterQuality: FilterQuality.none,))),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(episode.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      child: Text(episode.description,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis)),
                )
              ]),
            ),
          ),
        );
      },
    );
  }
}
