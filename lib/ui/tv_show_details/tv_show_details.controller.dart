import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/cast_info.model.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/model/tv_shows_info.model.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/core/service/tv_shows.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class TvShowsDetailsController extends GenericController with GetSingleTickerProviderStateMixin{
  static TvShowsDetailsController get instance => Get.find();
  final TvShowService tvShowsService = Get.find();
  final ColorGenerator colorGenerator = Get.find();
  Rx<TvInfoModel> tmdbData = TvInfoModel().obs;
  RxList<TvModel> similar = List<TvModel>.empty().obs;
  RxList<CastInfo> cast = List<CastInfo>.empty().obs;
  RxList<ImageBackdrop> backdrops = List<ImageBackdrop>.empty().obs;
  RxList<TrailerModel> trailers  = List<TrailerModel>.empty().obs;
  Rx<Color> color = Colors.black.obs;
  Rx<Color> textColor = Colors.white.obs;
  RxList<ImageBackdrop> images = List<ImageBackdrop>.empty().obs;
  Rx<SocialMediaInfo> sinfo = SocialMediaInfo().obs;
  late String image = Get.arguments;
  RxBool isLoading  = true.obs;
  RxBool isError = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  getDetails(String id) async{
    try {
      isLoading.value = true;
      tmdbData.value = await tvShowsService.getTvDataById(id);
      final trailerList = await tvShowsService.getTvShowTrailerById(id);
      trailers.value = trailerList.trailers!;
      final castList = await tvShowsService.getTvCastById(id);
      cast.value = castList.castList ?? [];
      isLoading.value = false;
      final similarList = await tvShowsService.getSimilarShows(id);
      similar.value = similarList.movies ?? [];
      sinfo.value = await tvShowsService.getSocialMedia(id);
      color.value = await colorGenerator.getImagePalette(
          NetworkImage(tmdbData.value.backdrops));
      textColor.value = colorGenerator.calculateTextColor(color.value);
      /*
      final backDropList = await tvShowsService.getTvImagesById(id);
      images.value = backDropList.backdrops!;
      List<ImageBackdrop> allImages = [];
      allImages.addAll(backDropList.backdrops!);
      allImages.addAll(backDropList.logos!);
      allImages.addAll(backDropList.posters!);*/
    }catch(e){
      isError.value = true;
      isLoading.value = false;
    }
  }
}