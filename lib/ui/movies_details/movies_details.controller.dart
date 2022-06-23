import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moviebox/core/model/cast_info.model.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class MoviesDetailsController extends GenericController with GetSingleTickerProviderStateMixin{
  static MoviesDetailsController get instance => Get.find();

  final MoviesService moviesService = Get.find();
  final ColorGenerator colorGenerator = Get.find();
  Rx<MovieInfoModel> tmdbData = MovieInfoModel().obs;
  Rx<MovieInfoImdb> imdbData = MovieInfoImdb().obs;
  RxList<MovieModel> similar = List<MovieModel>.empty().obs;
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
  final formatCurrency = new NumberFormat.simpleCurrency();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  
  getDetails(String id) async{
    try {
      isLoading.value = true;
      tmdbData.value = await moviesService.getMovieDataById(id);
      final trailerList = await moviesService.getMovieTrailerById(id);
      trailers.value = trailerList.trailers!;
      final castList = await moviesService.getMovieCastById(id);
      cast.value = castList.castList ?? [];
      isLoading.value = false;
      imdbData.value = await moviesService.getImdbDataById(
          tmdbData.value.imdbid!);
      // final backDropList = await moviesService.getMovieImagesById(id);
      //images.value = backDropList.backdrops!;
      final similarList = await moviesService.getSimilarMovies(id);
      similar.value = similarList.movies ?? [];
      sinfo.value = await moviesService.getSocialMedia(id);

      /*List<ImageBackdrop> allImages = [];
      allImages.addAll(backDropList.backdrops!);
      allImages.addAll(backDropList.logos!);
      allImages.addAll(backDropList.posters!);*/
      color.value = await colorGenerator.getImagePalette(
          NetworkImage(tmdbData.value.backdrops!));
      textColor.value = colorGenerator.calculateTextColor(color.value);
    }catch(e){
      print(e);
      isError.value = true;
      isLoading.value = false;
    }
  }

  String formattedCurrency() {
    return formatCurrency.format(tmdbData.value.revenue??0);
  }
}