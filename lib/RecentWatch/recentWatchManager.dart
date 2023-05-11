import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../RecentWatch/recentShow.dart';
import 'package:postreamv3/RecentWatch/recentAnime';

/// [RecentWatchManager] keeps track of a list of recently watched anime backing
/// it up in a local database in between app sessions.
class RecentWatchManager extends GetxController {
  /// List of recently watched anime
  List<RecentAnime> _recentAnimes = [];
  final updater = new ValueNotifier(0);

  List<RecentAnime> get animeList => [..._recentAnimes.reversed];

  /// Loads all locally stored entries from the recent anime local database
  Future<List<RecentAnime>> loadRecentAnimeFromDatabase() async {
    final result = await recentShow.instance.getAllRecentAnime();
    if (result != null) {
      _recentAnimes = result;
      updater.value++;
      return animeList;
    }
    return animeList;
  }

  /// Adds a new recent anime entry to the local database
  void addAnimeToRecent(RecentAnime anime, List<RecentAnime> AL) {
    print(AL);
    for (var rm in AL) {
      if (rm.id == anime.id) {
        recentShow.instance.remove(anime.id);
        print("TEST");
      }
    }
    _recentAnimes.removeWhere((rm) => (rm.id == anime.id));
    _recentAnimes.add(anime);
    recentShow.instance.insert(anime);
    update();
  }

  /// Removes a recent anime entry from the local database with the provided id
  void removeAnime(String id) {
    _recentAnimes.removeWhere((rm) => rm.id == id);
    recentShow.instance.remove(id);
    update();
  }

  /// Clears all locally stored entries from the recent anime local database
  void removeAllAnime() {
    _recentAnimes.clear();
    recentShow.instance.removeAll();
    update();
  }
}