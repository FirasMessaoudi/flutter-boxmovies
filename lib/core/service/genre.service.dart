import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/shared/util/constant.dart';
import 'package:moviebox/shared/util/utilities.dart';

class GenreService {
  var movieResultsCount;
  var showsResultsCount;

  Future<MovieModelList> getMovies(String id, int no) async {
    String? language = Get.locale!.languageCode;
    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=$language&sort_by=popularity.desc&with_genres=$id&page=$no');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    movieResultsCount = data1['total_results'];

    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getTvShows(String id, int no) async {
    String? language = Get.locale!.languageCode;

    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/tv?api_key=$apiKey&language=$language&sort_by=popularity.desc&with_genres=$id&page=$no');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];

    showsResultsCount = data1['total_results'];

    return TvModelList.fromJson(list);
  }
}
