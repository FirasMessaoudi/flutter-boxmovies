import 'dart:async';

import 'package:moviebox/core/model/watchlist.model.dart';
import 'package:moviebox/core/service/watchlist.service.dart';
import 'package:moviebox/shared/util/profile_list_items.dart';

class WatchListStream {
  final StreamController<List<FavoriteWatchListModel>> controller =
      StreamController<List<FavoriteWatchListModel>>();
  final repo = WatchListService();
  var isfinish = false;
  var lastRepo;
  List<FavoriteWatchListModel> movies = [];

  void addData(ProfileItems type, bool? watched) async {
    final List<dynamic> favorites;
    if (type == ProfileItems.movies) {
      favorites = watched == null
          ? await repo.getWatchList(null, true)
          : await repo.getFilteredWatchlist(null, true, watched);
    } else {
      if(watched==null) {
        favorites = await repo.getTvList(null);
      }else{
        favorites = await repo.getFilteredTvList(null, watched);
      }
    }
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;
    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    lastRepo = favorites[1];
  }

  void getNextMovies(ProfileItems type, bool? watched) async {
    final List<dynamic> favorites;
    if (type == ProfileItems.movies) {
      favorites = watched == null
          ? await repo.getWatchList(lastRepo, true)
          : await repo.getFilteredWatchlist(lastRepo, true, watched);
    } else {
      favorites = await repo.getTvList(lastRepo);
    }
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
