import 'dart:async';

import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/search_repo.dart';



class GetSearchResults {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();
  final repo = SearchRepo();
  final discoverRepo = MoviesRepo();
  var isfinish = false;
  int page = 1;
  List<MovieModel> movies = [];
  void addData(String query) async {
    print(page);
    if(query!='') {
      final fetchedmovies = await repo.getMovies(query, page);
      controller.sink.add(fetchedmovies.movies);
      movies.addAll(fetchedmovies.movies);
    }else {
      final fetchedmovies = await discoverRepo.discover(page);
      controller.sink.add(fetchedmovies.movies);
      movies.addAll(fetchedmovies.movies);
    }

    page++;
  }

  void getNextMovies(String name) async {
     if(name!='') {
       final fetchedmovies = await repo.getMovies(name, page);
       controller.sink.add(fetchedmovies.movies);
       movies.addAll(fetchedmovies.movies);
     }else {
       final fetchedmovies = await discoverRepo.discover(page);
       controller.sink.add(fetchedmovies.movies);
       movies.addAll(fetchedmovies.movies);
     }

    page++;
  }

  void dispose() {
    controller.close();
  }
}
