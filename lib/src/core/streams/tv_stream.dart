import 'dart:async';

import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/repo/search_repo.dart';
import 'package:moviebox/src/core/repo/tv_shows_repo.dart';

class GetSearchResultsTv {
  final StreamController<List<TvModel>> controller =
      StreamController<List<TvModel>>();
  final repo = SearchRepo();
  final discoverRepo = TVRepo();
  var isfinish = false;
  int page = 1;
  List<TvModel> tvshows = [];

  void addData(String query) async {
    if (query != '') {
      final fetchedTv = await repo.getTvShows(query, page);
      controller.sink.add(fetchedTv.movies);
      tvshows.addAll(fetchedTv.movies);
    } else {
      final fetchedTv = await discoverRepo.discover(page);
      controller.sink.add(fetchedTv.movies);
      tvshows.addAll(fetchedTv.movies);
    }
    page++;
  }

  void getNextMovies(String name) async {
    if (name != '') {
      final fetchedTv = await repo.getTvShows(name, page);
      controller.sink.add(fetchedTv.movies);
      tvshows.addAll(fetchedTv.movies);
    } else {
      final fetchedTv = await discoverRepo.discover(page);
      controller.sink.add(fetchedTv.movies);
      tvshows.addAll(fetchedTv.movies);
    }

    page++;
  }

  void dispose() {
    controller.close();
  }
}
