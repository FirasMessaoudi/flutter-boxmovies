import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/genres.model.dart';
import 'package:moviebox/core/model/network.model.dart';
import 'package:moviebox/core/streams/all_tv_stream.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class AllTvShowsController extends GenericController with  GetSingleTickerProviderStateMixin{
  static AllTvShowsController get instance => Get.find();
  late AllTvStream repo;

  late ScrollController scrollController;
  String globalQuery = '';
  final genreList = GenresList.fromJson(tvGenreslist).list;
  final networks = NetworksList.fromJson(networklist).list;
  final List<String> sortListLabels = [
    "filter.popularity".tr,
    "filter.vote".tr,
  ];
  final List<String> sortListValues = [
    "popularity.desc",
    "vote_average.desc",
  ];
  String selectedGenres = '';
  String selectedStudios = '';
  String selectedCert = '';
  String sortBy = '';
  String country = '';
  @override
  void onInit() {
    // TODO: implement onInit
    repo = AllTvStream();
    scrollController = ScrollController();
    repo.addData('');
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(globalQuery);
      }
    }
    update();
  }

  List<String> getId(list, [isGenre = false]) {
    List<String> ids = [];
    for (int i = 0; i < list.length; i++) {
      if (!isGenre)
        ids.add(list[i].id);
      else
        ids.add(list[i].idTv);
    }
    return ids;
  }

  List<String> getNames(list, [isGenre = false]) {
    List<String> names = [];
    for (int i = 0; i < list.length; i++) {
      if (!isGenre)
        names.add(list[i].name);
      else {
        Get.locale!.languageCode == 'ar'
            ? names.add(list[i].nameAr)
            : names.add(list[i].name);
      }
    }
    return names;
  }

  void search([bool reset = false]) async {
    //repo.dispose();
    repo = new AllTvStream();
    if (reset == true) {
      repo.addData('');
    }
    repo.addData(makeQuery());
    sortBy = '';
    selectedCert = '';
    selectedStudios = '';
    selectedGenres = '';
    country = '';
  }

  makeQuery() {
    String query = '';
    if (sortBy != '') {
      query += '&sort_by=$sortBy';
    }
    if (selectedStudios != '') {
      query += '&with_networks=$selectedStudios';
    }
    if (selectedGenres != '') {
      query += '&with_genres=$selectedGenres';
    }
    if (selectedCert != '') {
      query += '&certification_country=US&certification=$selectedCert';
    }
    globalQuery = query;
    return globalQuery;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    repo.dispose();
    super.dispose();
  }
}