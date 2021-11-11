
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(WatchlistState.initial());
  final repo = WatchListRepo();
  void init(String movieid) async {
    bool value =  await  repo.existInWatchList(movieid);
      if (value) {
        emit(state.copyWith(isWatchlist: true));
      } else {
        emit(state.copyWith(isWatchlist: false));
      }
  }
  void toggleWatchlist({
    required String name,
    required String movieid,
    required String poster,
    required String date,
    required double rate,
    required bool isMovie,
    required String backdrop,
    List<int>? genres


  }) async {

    if (!state.isWatchlist) {
      emit(state.copyWith(isWatchlist: true));
     await repo.addToWatchList(movieid,name,poster,date,rate,isMovie,backdrop,genres);
    } else {
      emit(state.copyWith(isWatchlist: false));
     await repo.deleteFromWatchList(movieid);
    }
  }
}
