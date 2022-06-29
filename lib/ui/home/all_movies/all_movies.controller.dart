import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/core/model/genres.model.dart';
import 'package:moviebox/core/model/network.model.dart';
import 'package:moviebox/core/streams/all_movies_stream.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class AllMoviesController extends GenericController with  GetSingleTickerProviderStateMixin{
  static AllMoviesController get instance => Get.find();
  late AllMoviesStream repo;
  late ScrollController scrollController;
  String globalQuery = '';
  final genres = GenresList.fromJson(genreslist).list;
  final companies = NetworksList.fromJson(companylist).list;
  final List<String> sortListLabels = [
    "filter.popularity".tr,
    "filter.vote".tr,
    "Box Office",
  ];
  final List<String> sortListValues = [
    "popularity.desc",
    "vote_average.desc",
    "revenue.desc",
  ];
  String selectedGenres = '';
  String selectedStudios = '';
  String selectedCert = '';
  String sortBy = '';
  String country = '';
  @override
  void onInit() {
    // TODO: implement onInit
    repo = AllMoviesStream();
    scrollController = ScrollController();
    repo.addData(globalQuery);
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  List<String> getId(list) {
    List<String> ids = [];
    for (int i = 0; i < list.length; i++) ids.add(list[i].id);

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
    repo = new AllMoviesStream();
    if (reset == true) {
      repo.addData('');
    }
    repo.addData(makeQuery());
    sortBy = '';
    selectedCert = '';
    selectedStudios = '';
    selectedGenres = '';
    country = '';
    update();
  }

  makeQuery() {
    String query = '';
    if (sortBy != '') {
      query += '&sort_by=$sortBy';
    }
    if (selectedStudios != '') {
      query += '&with_companies=$selectedStudios';
    }
    if (selectedGenres != '') {
      query += '&with_genres=$selectedGenres';
    }
    if (selectedCert != '') {
      query += '&certification_country=US&certification=$selectedCert';
    }
    if (country != '') {
      query += '&with_original_language=$country';
    }
    globalQuery = query;
    return globalQuery;
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(globalQuery);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    repo.dispose();
    super.dispose();
  }
}