import 'dart:async';

import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';

class AllMoviesStream {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();

  Stream<List<MovieModel>> get _streamController => controller.stream;

  final repo = MoviesRepo();
  var isfinish = false;
  int page = 1;
  List<MovieModel> movies = [];

  void addData(String query, [bool isFilter = false]) async {
    final fetchedmovies = await repo.filter(page, query);
    controller.sink.add(fetchedmovies.movies);
    movies.addAll(fetchedmovies.movies);
    page++;
  }

  void getNextMovies(String query) async {
    final fetchedmovies = await repo.filter(page, query);
    controller.sink.add(fetchedmovies.movies);
    movies.addAll(fetchedmovies.movies);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
