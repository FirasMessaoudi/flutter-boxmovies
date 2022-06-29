import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/core/service/tv_episode_watchlist.service.dart';
import 'package:moviebox/shared/widget/watched_episode/watched_episode_state.dart';

class WatchedEpisodeCubit extends Cubit<WatchedEpisodeState> {
  WatchedEpisodeCubit() : super(WatchedEpisodeState.initial());
  final repo = new TvWatchlistService();

  void init(String tvName, String tvId, String epId) async {
    var id = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(id)
        .collection('tvList')
        .doc(tvId)
        .get()
        .then((value) {
      if (value.exists) {
        // tv is in watchlist , now we heck if the episode is watched
        FirebaseFirestore.instance
            .collection('UserTvList')
            .doc(id)
            .collection('allEpisodes')
            .doc(epId)
            .get()
            .then((value) => {
                  if (value.exists)
                    {
                      emit(state.copyWith(
                          isTvInWatchlist: true,
                          isWatchedEpisode: true,
                          tvName: tvName))
                    }
                  else
                    {
                      emit(state.copyWith(
                          isTvInWatchlist: true,
                          isWatchedEpisode: false,
                          tvName: tvName))
                    }
                });
      } else {
        emit(state.copyWith(isTvInWatchlist: false, isWatchedEpisode: false));
      }
    });
  }

  addToExistingTvList(String epTitle, String epId, String tvName, String tvId,
      double epRate, String epRuntime) async {
    emit(state.copyWith(
        isTvInWatchlist: true, isWatchedEpisode: true, tvName: tvName));
    await repo.addToExistingTv(epTitle, epId, tvName, tvId, epRate, epRuntime);
  }

  addToNewTvList(
      String epTitle,
      String epId,
      String tvName,
      String tvGenre,
      String tvDate,
      double tvRate,
      String tvId,
      String tvImage,
      double epRate,
      String epRuntime,
      String backdrop) async {
    emit(state.copyWith(
        isTvInWatchlist: true, isWatchedEpisode: true, tvName: tvName));
    await repo.addToNewTvWatchList(epTitle, epId, tvName, tvGenre, tvDate,
        tvRate, tvId, tvImage, epRate, epRuntime, backdrop);
  }

  void deleteEpisode(String tvId, String epId, String tvName) async {
    emit(state.copyWith(
        isTvInWatchlist: true, isWatchedEpisode: false, tvName: tvName));
    await repo.deleteEpisode(tvId, epId);
  }
}
