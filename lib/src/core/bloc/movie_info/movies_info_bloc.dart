import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_state.dart';

class MoviesInfoBloc extends Bloc<MoviesInfoEvent, MoviesInfoState> {
  MoviesInfoBloc() : super(MoviesInfoInitial());
  final repo = MoviesRepo();
  final colorRepo = ColorGenrator();
  @override
  Stream<MoviesInfoState> mapEventToState(
    MoviesInfoEvent event,
  ) async* {
    if (event is LoadMoviesInfo) {
      try {
        yield MoviesInfoLoading();
        print(event.id);
        final MovieInfoModel tmdbdata = await repo.getMovieDataById(event.id);
        final Color color =
            await colorRepo.getImagePalette(NetworkImage(tmdbdata.backdrops));
        final Color textColor = colorRepo.calculateTextColor(color);
      
        final trailers = await repo.getMovieTrailerById(event.id);
        final images = await repo.getMovieImagesById(event.id);
        final cast = await repo.getMovieCastById(event.id);
        final similar = await repo.getSimilarMovies(event.id);
        final sinfo = await repo.getSocialMedia(event.id);
        List<ImageBackdrop> allImages = [];
        allImages.addAll(images.backdrops);
        allImages.addAll(images.logos);
        allImages.addAll(images.posters);
          final MovieInfoImdb imdbData =
            await repo.getImdbDataById(tmdbdata.imdbid);
        yield MoviesInfoLoaded(
          imdbData: imdbData,
          trailers: trailers.trailers,
          backdrops: images.backdrops,
          tmdbData: tmdbdata,
          cast: cast.castList,
          color: color,
          textColor: textColor,
          similar: similar.movies,
          images: allImages,
          sinfo: sinfo
        );
      } catch (e) {
        print('erreur');
        print(e.toString());
        yield MoviesInfoError();
      }
    }
  }
}
