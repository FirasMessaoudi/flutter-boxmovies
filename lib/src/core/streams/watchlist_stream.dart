
import 'dart:async';

import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';

class WatchListStream {
  final StreamController<List<FavoriteWatchListModel>> controller =
  StreamController<List<FavoriteWatchListModel>>();
  final repo = WatchListRepo();
  var isfinish = false;
  var lastRepo;
  List<FavoriteWatchListModel> movies = [];
  void addData(ProfileItems type, bool? watched) async {
    final favorites = watched==null?await repo.getWatchList(null,type==ProfileItems.movies?true:false):await repo.getFilteredWatchlist(null,type==ProfileItems.movies?true:false, watched);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;
    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    lastRepo = favorites[1];
  }

  void getNextMovies(ProfileItems type, bool? watched) async {
    final favorites =  watched==null?await repo.getWatchList(lastRepo,type==ProfileItems.movies?true:false): await repo.getFilteredWatchlist(lastRepo, type==ProfileItems.movies?true:false, watched);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;

    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    if (favorites[1] == null) {
      isfinish = true;
    } else {
      lastRepo = favorites[1];
    }
  }

  void dispose() {
    controller.close();
  }
}
