import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/repo/fav_repo.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/favorite_button/cubit/fav_state.dart';

class FavMovieCubit extends Cubit<FavMovieState> {
  FavMovieCubit() : super(FavMovieState.initial());

  final repo = FavRepo();

  void init(String movieid) async {
    bool value = await repo.existInFav(movieid);
    if (value) {
      emit(state.copyWith(isFavMovie: true));
    } else {
      emit(state.copyWith(isFavMovie: false));
    }
  }

  void toggleFav(
      {required String name,
      required String movieid,
      required FavType type,
      required String poster,
      required String date,
      required double rate,
      required String age,
      required String backdrop,
      List<int>? genres}) async {
    if (!state.isFavMovie) {
      emit(state.copyWith(isFavMovie: true));

      await repo.addToFav(
          movieid, name, type, poster, date, rate, age, backdrop, genres);
    } else {
      emit(state.copyWith(isFavMovie: false));
      await repo.deleteFromFav(movieid);
    }
  }
}
