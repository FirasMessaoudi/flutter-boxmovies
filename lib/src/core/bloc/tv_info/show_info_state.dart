import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:moviebox/src/core/model/cast_info.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';

abstract class ShowInfoState extends Equatable {
  const ShowInfoState();

  @override
  List<Object> get props => [];
}

class ShowInfoInitial extends ShowInfoState {}

class ShowInfoLoading extends ShowInfoState {}

class ShowInfoError extends ShowInfoState {}

class ShowInfoNetworkError extends ShowInfoState {}

class ShowInfoLoaded extends ShowInfoState {
  final TvInfoModel tmdbData;
  final List<TvModel> similar;
  final List<CastInfo> cast;
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> images;
  final List<TrailerModel> trailers;
  final Color color;
  final Color textColor;
  final SocialMediaInfo sinfo;

  ShowInfoLoaded(
      {required this.images,
      required this.tmdbData,
      required this.similar,
      required this.cast,
      required this.backdrops,
      required this.trailers,
      required this.color,
      required this.textColor,
      required this.sinfo});
}
