import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/core/model/season.info.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/core/service/season.service.dart';

part 'season_info_event.dart';
part 'season_info_state.dart';

class SeasonInfoBloc extends Bloc<SeasonInfoEvent, SeasonInfoState> {
  SeasonInfoBloc() : super(SeasonInfoInitial());
  final repo = SeasonService();
  final colorRepo = ColorGenerator();

  @override
  Stream<SeasonInfoState> mapEventToState(
    SeasonInfoEvent event,
  ) async* {
    if (event is LoadSeasonInfo) {
      try {
        yield SeasonInfoLoading();
        final seasonInfo = await repo.getSeasonInfo(event.id, event.snum);
        final Color color = await colorRepo
            .getImagePalette(NetworkImage(seasonInfo.posterPath));
        final Color textColor = colorRepo.calculateTextColor(color);

        final castList = await repo.getseasonCastById(event.id, event.snum);

        final trailers = await repo.getSeasonTrailerById(event.id, event.snum);
        final images = await repo.getSeasonImagesById(event.id, event.snum);
        yield SeasonInfoLoaded(
          cast: castList.castList??[],
          seasonInfo: seasonInfo,
          trailers: trailers.trailers??[],
          backdrops: images.backdrops??[],
          color: color,
          textColor: textColor,
        );
      } catch (e) {
        yield SeasonInfoLoadError();
      }
    }
  }
}
