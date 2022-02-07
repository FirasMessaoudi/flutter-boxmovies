import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/widget/tv_show_info.dart';

import '../../../themes.dart';

class BackdropPoster extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final double rate;
  final bool isMovie;
  final Color? color;

  const BackdropPoster({
    Key? key,
    required this.poster,
    required this.rate,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.isMovie,
    this.color,
  }) : super(key: key);

  moveToInfo(BuildContext context) {
    print(isMovie);
    if (isMovie) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    MoviesInfoBloc()..add(LoadMoviesInfo(id: this.id)),
                child: MoivesInfo(
                  image: this.backdrop,
                  title: this.name,
                ),
              )));
    } else if (!isMovie) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    ShowInfoBloc()..add(LoadTvInfo(id: this.id)),
                child: TvInfo(
                  image: this.backdrop,
                  title: this.name,
                ),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: () {
          print('on tap');
          moveToInfo(context);
        },
        child: Container(
         // constraints: BoxConstraints(minHeight: 240),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  width: 330,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: backdrop,
                      fit: BoxFit.cover,
                    ),
                  )),
              // SizedBox(height: 5),
              Container(
                // width: 330,
                // height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
