import 'dart:async';

import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/service/movie.service.dart';

class AllMoviesStream {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();

  Stream<List<MovieModel>> get streamController => controller.stream;

  final repo = MoviesService();
  var isfinish = false;
  int page = 1;
  List<MovieModel> movies = [];

  void addData(String query, [bool isFilter = false]) async {
    final fetchedmovies = await repo.filter(page, query);
    controller.sink.add(fetchedmovies.movies!);
    movies.addAll(fetchedmovies.movies!);
    page++;
  }

  void getNextMovies(String query) async {
    final fetchedmovies = await repo.filter(page, query);
    controller.sink.add(fetchedmovies.movies!);
    movies.addAll(fetchedmovies.movies!);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
