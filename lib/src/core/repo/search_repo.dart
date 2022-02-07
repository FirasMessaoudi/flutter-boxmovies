import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/people_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/shared/util/constant.dart';
import 'package:moviebox/src/shared/util/utilities.dart';

class SearchRepo {
  var movieResultsCount;
  var showsResultsCount;
  var peopleResultsCount;

  Future<MovieModelList> getMovies(String query, int page) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=$language&query=$query&page=$page');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    movieResultsCount = data1['total_results'];
    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getTvShows(String query, int page) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=$apiKey&language=$language&query=$query&page=$page&include_adult=true');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    showsResultsCount = data1['total_results'];
    return TvModelList.fromJson(list);
  }

  Future<PeopleModelList> getPeoples(String query, int page) async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/person?api_key=$apiKey&language=$language&query=$query&page=$page');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    peopleResultsCount = data1['total_results'];
    return PeopleModelList.fromJson(list);
  }

  Future<MovieModelList> getUpcomingMovies() async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getUpcomingTvShows() async {
    String? language = await currentLanguage();

    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey&language=$language');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }
}
