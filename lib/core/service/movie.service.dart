import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moviebox/core/model/cast_info.model.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/shared/util/constant.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorGenerator {
  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }

  Color calculateTextColor(Color background) {
    return background.computeLuminance() >= 0.4 ? Colors.black : Colors.white;
  }
}

class MoviesService {
  String _url = "api.themoviedb.org";

  Future<MovieModelList> getMovieByType(String program, String type) async {
    String? language = Get.locale!.languageCode;

    final url = Uri.https(
        _url, '3/$type', {'api_key': '$apiKey', 'language': '$language'});
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> filter(int page, String query) async {
    String? language = Get.locale!.languageCode;
    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie/?api_key=$apiKey&language=$language&page=$page$query');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getMovies() async {
    String? language = Get.locale!.languageCode;

    var url = Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> discover(int page) async {
    String? language = Get.locale!.languageCode;

    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie/?api_key=$apiKey&language=$language&page=$page');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getNowPlayingMovies() async {
    String? language = Get.locale!.languageCode;

    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getTopRatedMovies() async {
    String? language = Get.locale!.languageCode;

    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=$language&page=${Random().nextInt(100)}');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getSimilarMovies(String id) async {
    String? language = Get.locale!.languageCode;

    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/similar?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieInfoModel> getMovieDataById(String id) async {
    String? language = Get.locale!.languageCode;
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final imdb_id = data['imdb_id'];
    return MovieInfoModel.fromJson(data);
  }

  Future<TrailerList> getMovieTrailerById(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=$apiKey');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TrailerList.fromJson(data);
  }

  Future<ImageBackdropList> getMovieImagesById(String id) async {
    List<dynamic> backdrops = [];
    List<dynamic> posters = [];
    List<dynamic> logos = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/images?api_key=$apiKey&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    backdrops.addAll(data6['backdrops']);
    logos.addAll(data6['logos']);
    posters.addAll(data6['posters']);
    return ImageBackdropList.fromJson(backdrops, posters, logos);
  }

  Future<CastInfoList> getMovieCastById(String id) async {
    String? language = Get.locale!.languageCode;

    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=$apiKey&language=$language&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastInfoList.fromJson(data);
  }

  Future<MovieInfoImdb> getImdbDataById(String id) async {
    print(id);
    var omdburl = Uri.parse('https://www.omdbapi.com/?i=$id&apikey=114165f2');
    final response = await http.get(omdburl);
    final data = json.decode(response.body);
    return MovieInfoImdb.fromJson(data);
  }

  Future<SocialMediaInfo> getSocialMedia(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/external_ids?api_key=$apiKey&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    return SocialMediaInfo.fromJson(data6);
  }
}
