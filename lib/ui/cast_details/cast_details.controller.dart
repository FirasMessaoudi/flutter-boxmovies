import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/cast_info.model.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/service/cast_movies.service.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class CastDetailsController extends GenericController  with  GetSingleTickerProviderStateMixin{
  static CastDetailsController get instance => Get.find();
  final CastService castService = Get.find();
  final ColorGenerator colorGenerator = Get.find();
  Rx<Color> color = Colors.black.obs;
  Rx<Color> textColor = Colors.white.obs;
  RxList<ImageBackdrop> images = List<ImageBackdrop>.empty().obs;
  Rx<SocialMediaInfo> socialInfo = SocialMediaInfo().obs;
  RxList<MovieModel> movies = List<MovieModel>.empty().obs;
  RxList<TvModel> tvShows = List<TvModel>.empty().obs;
  Rx<CastPersonalInfo> info = CastPersonalInfo().obs;
  late dynamic args = Get.arguments; //title and image
  RxBool isLoading  = true.obs;
  RxBool isError = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  
  findCast(String id) async {
    try {
      isLoading.value = true;
      info.value = await castService.getCastInfoById(id);

      socialInfo.value = await castService.getSocialMedia(id);
      isLoading.value = false;
      final MovieModelList moviesList = await castService.getCastMoviesById(id);
      movies.value = moviesList.movies ?? [];
      final TvModelList tvList = await castService.getCastTvById(id);
      tvShows.value = tvList.movies ?? [];
      final backDropList = await castService.getImageBackdropList(id);
      images.value = backDropList.backdrops ?? [];
      color.value = await colorGenerator.getImagePalette(
          NetworkImage(info.value.image ?? ''));
      textColor.value = colorGenerator.calculateTextColor(color.value);
    }catch(e){
      isError.value = true;
      isLoading.value = false;
    }
  }
}