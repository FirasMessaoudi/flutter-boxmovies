import 'dart:async';

import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/repo/fav_repo.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';

class FavoritesStream {
  final StreamController<List<FavoriteWatchListModel>> controller =
      StreamController<List<FavoriteWatchListModel>>();
  final repo = FavRepo();
  var isfinish = false;
  var lastRepo;
  List<FavoriteWatchListModel> movies = [];

  void addData(FavType type) async {
    final favorites = await repo.getFavorite(null, type.index);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;
    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    lastRepo = favorites[1];
  }

  void getNextMovies(FavType type) async {
    final favorites = await repo.getFavorite(lastRepo, type.index);
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
