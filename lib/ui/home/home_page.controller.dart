import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/core/service/tv_shows.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';
import 'package:moviebox/shared/util/movie_type.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';

class HomePageController extends GenericController with GetSingleTickerProviderStateMixin{
  static HomePageController get instance => Get.find();
  final MoviesService _moviesService = Get.find();
  final TvShowService _tvShowService = Get.find();
  final AuthService _authService = Get.find();
  late ScrollController scrollController;
  Rx<MovieModelList> trendingMovies =MovieModelList().obs;
  Rx<MovieModelList> now_playing =MovieModelList().obs;
  Rx<MovieModelList> top_rated_movies =MovieModelList().obs;
  Rx<MovieModelList> upcoming_movies =MovieModelList().obs;
  Rx<TvModelList> popular_tv =TvModelList().obs;
  Rx<TvModelList> new_episodes =TvModelList().obs;
  RxBool isLoading = true.obs;
  static const int HOME_PAGE = 0;
  static const int DISCOVER = 1;
  static const int NETWORK = 2;
  static const int WELCOME = 3;
  RxInt tabIndex = HOME_PAGE.obs;
  RxDouble offset = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    isLoading(true);
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    initHomePage();
    super.onInit();
  }
  void changeTabIndex(int index) {
    switch (index) {
      case HOME_PAGE:
        HomePageController.instance.initHomePage();
        break;
      case DISCOVER:
        break;
      case NETWORK:
        break;
      case WELCOME:
        if(FirebaseAuth.instance.currentUser!=null)
          ProfileController.instance.initialization();
        break;
    }
    tabIndex.value = index;
    update();
  }
  initHomePage([musUpdate=false]) async{
    scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.linear);
    if(isLoading.isTrue && !musUpdate) {
      scrollController = ScrollController();
      scrollController.addListener(scrollListener);
      isLoading.value = true;
      now_playing.value = await _moviesService.getNowPlayingMovies();
      top_rated_movies.value = await _moviesService.getTopRatedMovies();
      trendingMovies.value = await _moviesService.getMovies();
      upcoming_movies.value =
      await _moviesService.getMovieByType('movie', MovieListType.upcoming);
      popular_tv.value = await _tvShowService.getPopularTvShows();
      new_episodes.value =
      await _tvShowService.getTvByType(MovieListType.newTv);
      isLoading.value = false;
    }

  }

  isLoggedIn(){
    return _authService.getCurrentUser() !=null;
  }

  scrollListener(){
    scrollController
      ..addListener(() {
        offset.value = scrollController.offset;
      });
  }


}