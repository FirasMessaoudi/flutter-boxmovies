import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/favorite_button/cubit/fav_cubit.dart';
import 'package:moviebox/src/shared/widget/favorite_button/cubit/fav_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../themes.dart';

class FavIcon extends StatelessWidget {
  final String title;
  final String movieid;
  final FavType type;
  final String poster;
  final String date;
  final double rate;
  final bool isEpisode;
  final String age;
  final Color color;
  final String backdrop;
  final List<int>? genres;

  const FavIcon(
      {Key? key,
      required this.title,
      required this.movieid,
      required this.type,
      required this.poster,
      required this.date,
      required this.rate,
      this.isEpisode = false,
      required this.age,
      required this.color,
      required this.backdrop,
      this.genres})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavMovieCubit, FavMovieState>(
      builder: (context, state) {
        if (!isEpisode) {
          return ListTile(
            onTap: () {
              BlocProvider.of<FavMovieCubit>(context).toggleFav(
                  name: title,
                  movieid: movieid,
                  type: type,
                  poster: poster,
                  date: date,
                  rate: rate,
                  age: age,
                  backdrop: backdrop,
                  genres: genres);
            },
            leading: state.isFavMovie
                ? Icon(
                    Icons.favorite,
                    color: color,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: color,
                  ),
            title: Text(
              state.isFavMovie ? 'bottom_sheet_actions.remove_from_favourite'.tr() : 'bottom_sheet_actions.add_to_favourite'.tr(),
              style: normalText.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          );
        } else {
          return IconButton(
              onPressed: () {
                BlocProvider.of<FavMovieCubit>(context).toggleFav(
                    name: title,
                    movieid: movieid,
                    type: type,
                    poster: poster,
                    date: date,
                    rate: rate,
                    age: age,
                    backdrop: backdrop,
                    genres: genres);
              },
              icon: state.isFavMovie
                  ? Icon(
                      Icons.favorite,
                      color: color,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: color,
                    ));
        }
      },
    );
  }
}
