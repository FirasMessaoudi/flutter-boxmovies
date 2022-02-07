import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_state.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../themes.dart';

class WatchListIcon extends StatelessWidget {
  final String title;
  final String movieid;
  final String poster;
  final String date;
  final double rate;
  final bool fromBottomSheet;
  final bool isMovie;
  final Color color;
  final bool justIcon;
  final String backdrop;
  final List<int>? genres;

  WatchListIcon(
      {Key? key,
      required this.title,
      required this.movieid,
      this.fromBottomSheet = false,
      required this.poster,
      required this.date,
      required this.rate,
      required this.isMovie,
      required this.color,
      this.justIcon = false,
      required this.backdrop,
      this.genres})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistCubit, WatchlistState>(
      builder: (context, state) {
        if (!fromBottomSheet) {
          if (!justIcon) {
            return InkWell(
              onTap: () {
                BlocProvider.of<WatchlistCubit>(context).toggleWatchlist(
                    name: title,
                    movieid: movieid,
                    poster: poster,
                    date: date,
                    rate: rate,
                    isMovie: isMovie,
                    backdrop: backdrop,
                    genres: genres);
              },
              child: Align(
                alignment: Alignment.topRight,
                child: state.isWatchlist
                    ? Icon(
                        Icons.done,
                        color: color,
                      )
                    : Icon(
                        Icons.add,
                        color: color,
                      ),
              ),
            );
          } else {
            return IconButton(
              icon: state.isWatchlist ? Icon(Icons.done) : Icon(Icons.add),
              onPressed: () {
                BlocProvider.of<WatchlistCubit>(context).toggleWatchlist(
                    name: title,
                    movieid: movieid,
                    poster: poster,
                    date: date,
                    rate: rate,
                    isMovie: isMovie,
                    backdrop: backdrop,
                    genres: genres);
              },
            );
          }
        } else {
          return ListTile(
            onTap: () {
              BlocProvider.of<WatchlistCubit>(context).toggleWatchlist(
                  name: title,
                  movieid: movieid,
                  poster: poster,
                  date: date,
                  rate: rate,
                  isMovie: isMovie,
                  backdrop: backdrop,
                  genres: genres);
            },
            leading: !state.isWatchlist
                ? Icon(
                    Icons.add,
                    color: color,
                  )
                : Icon(Icons.remove_circle, color: color),
            title: Text(
              state.isWatchlist ? 'bottom_sheet_actions.remove_from_watchlist'.tr() : 'bottom_sheet_actions.add_to_watchlist'.tr(),
              style: normalText.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          );
        }
      },
    );
  }
}
