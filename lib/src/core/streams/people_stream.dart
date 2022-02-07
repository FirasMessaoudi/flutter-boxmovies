import 'dart:async';

import 'package:moviebox/src/core/model/people_model.dart';
import 'package:moviebox/src/core/repo/cast_movies.dart';
import 'package:moviebox/src/core/repo/search_repo.dart';

class GetSearchResultsPeople {
  final StreamController<List<PeopleModel>> controller =
      StreamController<List<PeopleModel>>();
  final repo = SearchRepo();
  final popularRepo = CastMovies();
  var isfinish = false;
  int page = 1;
  List<PeopleModel> people = [];

  void addData(String query) async {
    if (query != '') {
      final fetchedTv = await repo.getPeoples(query, page);
      controller.sink.add(fetchedTv.peoples);
      people.addAll(fetchedTv.peoples);
    } else {
      final fetchedTv = await popularRepo.findPopular(page);
      controller.sink.add(fetchedTv.peoples);
      people.addAll(fetchedTv.peoples);
    }
    page++;
  }

  void getNextMovies(String name) async {
    if (name != '') {
      final fetchedTv = await repo.getPeoples(name, page);
      controller.sink.add(fetchedTv.peoples);
      people.addAll(fetchedTv.peoples);
    } else {
      final fetchedTv = await popularRepo.findPopular(page);
      controller.sink.add(fetchedTv.peoples);
      people.addAll(fetchedTv.peoples);
    }

    page++;
  }

  void dispose() {
    controller.close();
  }
}
