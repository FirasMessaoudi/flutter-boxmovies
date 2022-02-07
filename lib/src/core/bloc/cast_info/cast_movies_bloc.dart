import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_event.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_state.dart';
import 'package:moviebox/src/core/model/cast_info.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/repo/cast_movies.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';

class CastMoviesBloc extends Bloc<CastMoviesEvent, CastMoviesState> {
  CastMoviesBloc() : super(CastMoviesInitial());
  final repo = CastMovies();
  final colorRepo = ColorGenrator();

  @override
  Stream<CastMoviesState> mapEventToState(
    CastMoviesEvent event,
  ) async* {
    if (event is LoadCastInfo) {
      try {
        yield CastMoviesLoading();
        final CastPersonalInfo info = await repo.getCastInfoById(event.id);
        print(event.id);
        final Color color =
            await colorRepo.getImagePalette(NetworkImage(info.image));
        final Color textColor = colorRepo.calculateTextColor(color);
        final SocialMediaInfo socialInfo = await repo.getSocialMedia(event.id);
        final MovieModelList movies = await repo.getCastMoviesById(event.id);
        final TvModelList tvShows = await repo.getCastTvById(event.id);
        final images = await repo.getImageBackdropList(event.id);
        yield CastMoviesLoaded(
          info: info,
          movies: movies.movies,
          color: color,
          textColor: textColor,
          socialInfo: socialInfo,
          tvShows: tvShows.movies,
          images: images.backdrops,
        );
      } catch (e) {
        print(e.toString());
        yield CastMoviesError();
      }
    }
    // TODO: implement mapEventToState
  }
}
