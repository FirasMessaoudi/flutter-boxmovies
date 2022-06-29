import 'dart:async';

import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/service/search.service.dart';
import 'package:moviebox/core/service/tv_shows.service.dart';

class TvShowsResultSearchStream {
  final StreamController<List<TvModel>> controller =
      StreamController<List<TvModel>>();
  final repo = SearchService();
  final discoverRepo = TvShowService();
  var isfinish = false;
  int page = 1;
  List<TvModel> tvshows = [];

  void addData(String query) async {
    if (query != '') {
      final fetchedTv = await repo.getTvShows(query, page);
      controller.sink.add(fetchedTv.movies!);
      tvshows.addAll(fetchedTv.movies!);
    } else {
      final fetchedTv = await discoverRepo.discover(page);
      controller.sink.add(fetchedTv.movies!);
      tvshows.addAll(fetchedTv.movies!);
    }
    page++;
  }

  void getNextMovies(String name) async {
    if (name != '') {
      final fetchedTv = await repo.getTvShows(name, page);
      controller.sink.add(fetchedTv.movies!);
      tvshows.addAll(fetchedTv.movies!);
    } else {
      final fetchedTv = await discoverRepo.discover(page);
      controller.sink.add(fetchedTv.movies!);
      tvshows.addAll(fetchedTv.movies!);
    }

    page++;
  }

  void dispose() {
    controller.close();
  }
}
