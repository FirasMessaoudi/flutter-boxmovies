import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/shared/widget/watched_episode/watched_episode_cubit.dart';
import 'package:moviebox/shared/widget/watched_episode/watched_episode_state.dart';

class ToggleWatchEpisode extends StatelessWidget {
  String? epTitle;
  String? epId;
  String? tvName;
  String? tvGenre;
  String? tvDate;
  double? tvRate;
  String? tvId;
  String? tvImage;
  double? epRate;
  String? epRuntime;
  String? backdrop;

  ToggleWatchEpisode(
      {Key? key,
      this.epTitle,
      this.epId,
      this.tvName,
      this.tvGenre,
      this.tvDate,
      this.tvRate,
      this.tvId,
      this.tvImage,
      this.epRate,
      this.backdrop,
      this.epRuntime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchedEpisodeCubit, WatchedEpisodeState>(
        builder: (context, state) {
      return ElevatedButton(
          onPressed: () {
            if (state.isTvInWatchlist) {
              if (!state.isWatchedEpisode) {
                //addToExistingTvList
                BlocProvider.of<WatchedEpisodeCubit>(context)
                    .addToExistingTvList(
                        epTitle!, epId!, tvName!, tvId!, epRate!, epRuntime!);
              } else {
                //remove from allEpisode
                BlocProvider.of<WatchedEpisodeCubit>(context)
                    .deleteEpisode(tvId!, epId!, tvName!);
              }
            } else {
              //addToNewTvList
              BlocProvider.of<WatchedEpisodeCubit>(context).addToNewTvList(
                  epTitle!,
                  epId!,
                  tvName!,
                  tvGenre!,
                  tvDate!,
                  tvRate!,
                  tvId!,
                  tvImage!,
                  epRate!,
                  epRuntime!,
                  backdrop!);
            }
          },
          child: state.isWatchedEpisode
              ? Icon(Icons.done, color: Colors.white)
              : Icon(Icons.done, color: Colors.grey),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
            primary: state.isWatchedEpisode ? Colors.green : Colors.white,
            // <-- Button color
            onPrimary: Colors.red, // <-- Splash color
          ));
    });
  }
}
