import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_state.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/tv_shows_repo.dart';

class ShowInfoBloc extends Bloc<ShowInfoEvent, ShowInfoState> {
  ShowInfoBloc() : super(ShowInfoInitial());
  final repo = TVRepo();
  final colorRepo = ColorGenrator();

  @override
  Stream<ShowInfoState> mapEventToState(
    ShowInfoEvent event,
  ) async* {
    if (event is LoadTvInfo) {
      try {
        yield ShowInfoLoading();
        final TvInfoModel tmdbdata = await repo.getTvDataById(event.id);
        final Color color =
            await colorRepo.getImagePalette(NetworkImage(tmdbdata.backdrops));
        final Color textColor = colorRepo.calculateTextColor(color);

        final trailers = await repo.getTvShowTrailerById(event.id);
        final images = await repo.getTvImagesById(event.id);
        print(event.id);
        final cast = await repo.getTvCastById(event.id);
        final similar = await repo.getSimilarShows(event.id);
        final sinfo = await repo.getSocialMedia(event.id);
        List<ImageBackdrop> allImages = [];
        allImages.addAll(images.backdrops);
        allImages.addAll(images.logos);
        allImages.addAll(images.posters);
        yield ShowInfoLoaded(
            images: allImages,
            trailers: trailers.trailers,
            backdrops: images.backdrops,
            tmdbData: tmdbdata,
            cast: cast.castList,
            color: color,
            textColor: textColor,
            similar: similar.movies,
            sinfo: sinfo);
      } catch (e) {
        print(e.toString());
        yield ShowInfoError();
      }
    }
    // TODO: implement mapEventToState
  }
}
// 84958
