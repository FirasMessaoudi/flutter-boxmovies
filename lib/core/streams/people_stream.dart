import 'dart:async';

import 'package:moviebox/core/model/people.model.dart';
import 'package:moviebox/core/service/cast_movies.service.dart';
import 'package:moviebox/core/service/search.service.dart';

class PeopleResultSearchStream {
  final StreamController<List<PeopleModel>> controller =
      StreamController<List<PeopleModel>>();
  final repo = SearchService();
  final popularRepo = CastService();
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
