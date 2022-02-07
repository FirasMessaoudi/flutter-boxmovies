import 'dart:async';
import 'dart:math';

import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/search_repo.dart';
import 'package:moviebox/src/core/repo/tv_shows_repo.dart';

class CollectionStream {
  final StreamController<List<dynamic>> controller =
      StreamController<List<dynamic>>();
  final repo = SearchRepo();
  final discoverRepo = MoviesRepo();
  final discoverTv = TVRepo();
  var isfinish = false;
  int page = 1;
  List<dynamic> movies = [];

  void addData(String query) async {
    print(page);
    if (query != '') {
      final fetchedmovies = await repo.getMovies(query, page);
      final fetchTv = await repo.getTvShows(query, page);
      final result = merge(fetchedmovies, fetchTv);
      controller.sink.add(result);
      movies.addAll(result);
    } else {
      final fetchedmovies = await discoverRepo.discover(page);
      final fetchedTv = await discoverTv.discover(page);
      final result = merge(fetchedmovies, fetchedTv);
      controller.sink.add(result);
      movies.addAll(result);
    }

    page++;
  }

  void getNextMovies(String name) async {
    if (name != '') {
      final fetchedmovies = await repo.getMovies(name, page);
      final fetchTv = await repo.getTvShows(name, page);
      final result = merge(fetchedmovies, fetchTv);
      controller.sink.add(result);
      movies.addAll(result);
    } else {
      final fetchedmovies = await discoverRepo.discover(page);
      final fetchedTv = await discoverTv.discover(page);
      final result = merge(fetchedmovies, fetchedTv);

      controller.sink.add(result);
      movies.addAll(result);
    }

    page++;
  }

  void dispose() {
    controller.close();
  }

  List<dynamic> merge(MovieModelList moviesList, TvModelList tvList) {
    int size = max(moviesList.movies.length, tvList.movies.length);
    List<dynamic> result = [];
    for (int i = 0; i < size; i++) {
      if (i < moviesList.movies.length) result.add(moviesList.movies[i]);
      if (i < tvList.movies.length) result.add(tvList.movies[i]);
    }
    return result;
  }
}
