import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/season_info.dart';
import 'package:moviebox/src/shared/util/constant.dart';
import 'package:moviebox/src/shared/util/utilities.dart';

class SeasonRepo {

  Future<SeasonModel> getSeasonInfo(String id, String snum) async {
    String? language = await currentLanguage();

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/season/$snum?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return SeasonModel.fromJson(data);
  }

  Future<CastInfoList> getseasonCastById(String id, String snum) async {
    String? language = await currentLanguage();

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/season/$snum/credits?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastInfoList.fromJson(data);
  }

  Future<TrailerList> getSeasonTrailerById(String id, String snum) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/season/$snum/videos?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TrailerList.fromJson(data);
  }

  Future<ImageBackdropList> getSeasonImagesById(String id, String snum) async {
    List<dynamic> dataimages = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/season/$snum/images?api_key=$apiKey&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    dataimages.addAll(data6['posters']);
    return ImageBackdropList.fromJson(dataimages, [], []);
  }
}
