import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moviebox/core/model/cast_info.model.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/core/model/people.model.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/shared/util/constant.dart';
import 'package:moviebox/shared/util/utilities.dart';

class CastService {
  Future<MovieModelList> getCastMoviesById(String id) async {
    String? language = Get.locale!.languageCode;

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/movie_credits?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return MovieModelList.fromJson(data['cast']);
  }

  Future<TvModelList> getCastTvById(String id) async {
    String? language = Get.locale!.languageCode;

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/tv_credits?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return TvModelList.fromJson(data['cast']);
  }

  Future<CastPersonalInfo> getCastInfoById(String id) async {
    String? language = Get.locale!.languageCode;

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastPersonalInfo.fromJson(data);
  }

  Future<ImageBackdropList> getImageBackdropList(String id) async {
    List<dynamic> dataimages = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/images?api_key=$apiKey&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    dataimages.addAll(data6['profiles']);
    return ImageBackdropList.fromJson(dataimages, [], []);
  }

  Future<SocialMediaInfo> getSocialMedia(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/external_ids?api_key=$apiKey&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    return SocialMediaInfo.fromJson(data6);
  }

  Future<PeopleModelList> findPopular(int page) async {
    final urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/popular?api_key=$apiKey&language=en-US&page=$page');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    return PeopleModelList.fromJson(data6['results']);
  }
}
