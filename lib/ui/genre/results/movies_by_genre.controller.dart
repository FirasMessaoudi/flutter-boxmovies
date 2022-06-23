import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/streams/genre_movies.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class MoviesByGenreController extends GenericController with GetSingleTickerProviderStateMixin{
  static MoviesByGenreController get instance => Get.find();

  late MoviesGenreStream repo;
  late String query;
  late ScrollController scrollController;
  late String title = Get.arguments;
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }
  initSearch(String query){
    repo = MoviesGenreStream();
    scrollController = ScrollController();
    this.query = query;
    repo.addData(this.query);
    scrollController.addListener(_scrollListener);

  }
  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(query);
        print("at the end of list");
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    repo.dispose();
    repo.controller.close();
    super.dispose();
  }
}