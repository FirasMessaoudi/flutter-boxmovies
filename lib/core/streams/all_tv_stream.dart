import 'dart:async';

import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/service/tv_shows.service.dart';

class AllTvStream {
  final StreamController<List<TvModel>> controller =
      StreamController<List<TvModel>>();
  final repo = TvShowService();
  var isfinish = false;
  int page = 1;
  List<TvModel> shows = [];

  void addData(String query) async {
    print(page);
    final fetchedmovies = await repo.filter(page, query);
    controller.sink.add(fetchedmovies.movies!);
    shows.addAll(fetchedmovies.movies!);
    page++;
  }

  void getNextMovies(String query) async {
    final fetchedmovies = await repo.filter(page, query);
    controller.sink.add(fetchedmovies.movies!);
    shows.addAll(fetchedmovies.movies!);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
