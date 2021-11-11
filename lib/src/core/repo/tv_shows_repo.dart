import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:moviebox/src/core/model/cast_info.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'dart:convert';

import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';
import 'package:moviebox/src/shared/util/constant.dart';
import 'package:moviebox/src/shared/util/utilities.dart';


class TVRepo {
   String _url="api.themoviedb.org";
      Future<TvModelList> getTvByType(String type) async {
        String? language = await currentLanguage();

        final url = Uri.https(_url, '3/$type',
        {'api_key': '$apiKey', 'language': '$language'});
     final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }
  Future<TvModelList> getTvShows() async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/trending/tv/day?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvModelList> getPopularTvShows() async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=$language&page=${Random().nextInt(30)}');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvModelList> getTopRatedTvShows() async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&language=$language&page=${Random().nextInt(97)}');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }
 Future<TvModelList> discover(int page) async {
   String? language = await currentLanguage();

   var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/tv/?api_key=$apiKey&language=$language&page=$page');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }
  Future<TvModelList> getSimilarShows(String id) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/similar?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvInfoModel> getTvDataById(String id) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TvInfoModel.fromJson(data);
  }

  Future<TrailerList> getTvShowTrailerById(String id) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/videos?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TrailerList.fromJson(data);
  }

  Future<ImageBackdropList> getTvImagesById(String id) async {
    List<dynamic> backdrops = [];
    List<dynamic> posters = [];
    List<dynamic> logos = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/images?api_key=$apiKey&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    backdrops.addAll(data6['backdrops']);
    logos.addAll(data6['logos']);
    posters.addAll(data6['posters']);
    return ImageBackdropList.fromJson(backdrops, posters, logos);
  }

  Future<CastInfoList> getTvCastById(String id) async {
    String? language = await currentLanguage();

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/credits?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastInfoList.fromJson(data);
  }
      Future<TvModelList> getTvByNetwork(String id,int page) async {
        String? language = await currentLanguage();

        final url = Uri.https(_url, '3/discover/tv',
        {'api_key': '$apiKey','language':'$language', 'with_network':id,'page':page});
     final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }
   Future<TvModelList> filter(int page, String query) async {
     String? language = await currentLanguage();

     var url = Uri.parse(
         'https://api.themoviedb.org/3/discover/tv/?api_key=$apiKey$query&language=$language&page=$page');
     final response = await http.get(url);
     final data1 = json.decode(response.body);
     List<dynamic> list = data1['results'];
     return TvModelList.fromJson(list);
   }
   Future<SocialMediaInfo> getSocialMedia(String id) async {
     var urlNew = Uri.parse(
         'https://api.themoviedb.org/3/tv/$id/external_ids?api_key=$apiKey&language=en-US&include_image_language=en');
     final response6 = await http.get(urlNew);
     final data6 = json.decode(response6.body);
     return SocialMediaInfo.fromJson(data6);
   }
}
