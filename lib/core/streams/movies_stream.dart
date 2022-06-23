import 'dart:async';

import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/core/service/search.service.dart';

class MoviesResultsSearchStream {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();
  final repo = SearchService();
  final discoverRepo = MoviesService();
  var isfinish = false;
  int page = 1;
  List<MovieModel> movies = [];

  void addData(String query) async {
    print(page);
    if (query != '') {
      final fetchedmovies = await repo.getMovies(query, page);
      controller.sink.add(fetchedmovies.movies!);
      movies.addAll(fetchedmovies.movies!);
    } else {
      final fetchedmovies = await discoverRepo.discover(page);
      controller.sink.add(fetchedmovies.movies!);
      movies.addAll(fetchedmovies.movies!);
    }

    page++;
  }

  void getNextMovies(String name) async {
    if (name != '') {
      final fetchedmovies = await repo.getMovies(name, page);
      controller.sink.add(fetchedmovies.movies!);
      movies.addAll(fetchedmovies.movies!);
    } else {
      final fetchedmovies = await discoverRepo.discover(page);
      controller.sink.add(fetchedmovies.movies!);
      movies.addAll(fetchedmovies.movies!);
    }

    page++;
  }

  void dispose() {
    controller.close();
  }
}
