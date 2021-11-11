import 'dart:async';

import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/search_repo.dart';
import 'package:moviebox/src/core/repo/tv_shows_repo.dart';



class AllTvStream {
  final StreamController<List<TvModel>> controller =
      StreamController<List<TvModel>>();
  final repo = TVRepo();
  var isfinish = false;
  int page = 1;
  List<TvModel> shows = [];
  void addData(String query) async {
    print(page);
    final fetchedmovies = await repo.filter(page,query);
    controller.sink.add(fetchedmovies.movies);
    shows.addAll(fetchedmovies.movies);
    page++;
  }

  void getNextMovies(String query) async {
    final fetchedmovies = await repo.filter(page,query);
    controller.sink.add(fetchedmovies.movies);
    shows.addAll(fetchedmovies.movies);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
