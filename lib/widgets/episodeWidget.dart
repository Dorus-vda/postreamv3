import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postreamv3/main.dart';
import 'package:postreamv3/models/episode.dart';
import 'package:postreamv3/widgets/videoPlayer.dart';
import '../models/movie.dart';

class EpisodesWidget extends StatefulWidget {
  final List<Episode> episodes;
  final String movieId;
  final String cover;

  EpisodesWidget({
    required this.episodes,
    required this.movieId,
    required this.cover,
  });

  @override
  _EpisodesWidgetState createState() => _EpisodesWidgetState();
}

class _EpisodesWidgetState extends State<EpisodesWidget> {
  int startRange = 1;
  int endRange = 30;
  final int rangeIncrement = 30;

  /* void loadEpisodes(int start, int end) {
    final int episodeCount = widget.episodes.length;

    // Adjust the endRange to fit within the available episode range
    int adjustedEndRange = end;
    if (adjustedEndRange > episodeCount) {
      setState(() {
        adjustedEndRange = episodeCount;
      });
    }

    // Adjust the startRange if it exceeds the available episode range
    int adjustedStartRange = start;
    if (adjustedStartRange > episodeCount) {
      setState(() {
        adjustedStartRange = episodeCount - rangeIncrement + 1;
      });
    }

    // Update the ranges only if the adjusted ranges are different
    if (adjustedStartRange != startRange || adjustedEndRange != endRange) {
      setState(() {
        print(
            adjustedEndRange.toString() + " " + adjustedStartRange.toString());
        startRange = adjustedStartRange;
        endRange = adjustedEndRange;
      });
    }
  } */

  List<Widget> buildRangeButtons() {
    final List<Widget> buttons = [];
    final int episodeCount = widget.episodes.length;

    int currentStartRange = 1;
    int currentEndRange = rangeIncrement;

    while (currentStartRange <= episodeCount) {
      if (currentEndRange >= episodeCount) {
        currentEndRange = episodeCount;
      }
      final String buttonText = '${currentStartRange}-${currentEndRange}';
      final buttonStartRange = currentStartRange;
      final buttonEndRange = currentEndRange;

      buttons.add(
        GestureDetector(
          child: TextButton(
            onPressed: () {
              setState(() {
                startRange = buttonStartRange;
                endRange = buttonEndRange;
              });
            },
            child: Text(buttonText),
          ),
        ),
      );

      currentStartRange += rangeIncrement;
      currentEndRange += rangeIncrement;
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final displayedEpisodes = widget.episodes.sublist(
      startRange - 1,
      endRange.clamp(0, widget.episodes.length),
    );
    final rangeButtons = buildRangeButtons();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: rangeButtons,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedEpisodes.length,
          itemBuilder: (context, index) {
            final episode = displayedEpisodes[index];
            return GestureDetector(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        episodeId: episode.id,
                        movieId: widget.movieId,
                        isAnime: true,
                      ),
                    ),
                  );
                },
                title: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1.2,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: SizedBox(
                              height: 90,
                              child: Image.network(episode.image),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 180,
                              child: Text(
                                episode.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                        top: 8.0,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: Text(
                          episode.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
