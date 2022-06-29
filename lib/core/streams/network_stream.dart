import 'dart:async';

import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/service/network.service.dart';

class NetworkStream {
  final StreamController<List<TvModel>> controller =
      StreamController<List<TvModel>>();
  final repo = NetworkService();
  var isfinish = false;
  int page = 1;
  List<TvModel> tvshows = [];

  void addData(String query) async {
    final fetchedTv = await repo.getTvShows(query, page);
    controller.sink.add(fetchedTv.movies!);
    tvshows.addAll(fetchedTv.movies!);
    if (repo.showsResultsCount == tvshows.length) {
      isfinish = true;
    }
    page++;
  }

  void getNextMovies(String name) async {
    final fetchedTv = await repo.getTvShows(name, page);
    controller.sink.add(fetchedTv.movies!);
    tvshows.addAll(fetchedTv.movies!);
    if (repo.showsResultsCount == tvshows.length) {
      isfinish = true;
    }
    page++;
  }

  void dispose() {
    controller.close();
  }
}
