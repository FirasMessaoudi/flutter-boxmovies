import 'dart:async';

import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/service/network.service.dart';

class CompanyStream {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();
  final repo = NetworkService();
  var isfinish = false;
  int page = 1;
  List<MovieModel> tvshows = [];

  void addData(String query) async {
    final fetchedTv = await repo.getMovies(query, page);
    controller.sink.add(fetchedTv.movies!);
    tvshows.addAll(fetchedTv.movies!);
    if (repo.showsResultsCount == tvshows.length) {
      isfinish = true;
    }
    page++;
  }

  void getNextMovies(String name) async {
    final fetchedTv = await repo.getMovies(name, page);
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
