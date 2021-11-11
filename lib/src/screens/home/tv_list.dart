import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/tv_shows_repo.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info.dart';
import 'package:moviebox/src/screens/home/all_shows.dart';
import 'package:moviebox/src/shared/util/scroll_behaviour.dart';
import 'package:moviebox/src/shared/widget/movie_poster.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../themes.dart';

class TvListView extends StatefulWidget {
  final String type;
  final String title;
  final Function(int movieId, String img) onItemInteraction;

  TvListView(
      {Key? key,
      required this.type,
      required this.title,
      required this.onItemInteraction})
      : super(key: key);

  @override
  State createState() => _TvListViewState();
}

class _TvListViewState extends State<TvListView> {
  final TVRepo tvProvider = new TVRepo();
  @override
  Widget build(BuildContext context) {
    // movieListBloc.fetchMovieList(widget.type);
    return FutureBuilder<TvModelList>(
      future: tvProvider.getTvByType(widget.type),
      builder: (context, AsyncSnapshot<TvModelList> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
            // padding: EdgeInsets.all(20.0),
            // child: Center(child: CircularProgressIndicator())
            
            );
      },
    );
  }

  Widget buildContent(
      AsyncSnapshot<TvModelList> snapshot, BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title,
                      style: heading.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TvShows(),
                      ));
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "home.see_all".tr(),
                            style: normalText.copyWith(
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white
                                    : Colors.black)),
                        WidgetSpan(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ))
                      ]),
                    ),
                  )
                ],
              )),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 7),
                for (var i = 0; i < snapshot.data!.movies.length; i++)
                  MoviePoster(
                      poster: snapshot.data!.movies[i].poster,
                      name: snapshot.data!.movies[i].title,
                      backdrop: snapshot.data!.movies[i].backdrop,
                      date: snapshot.data!.movies[i].release_date,
                      id: snapshot.data!.movies[i].id,
                      color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                      isMovie: false)
              ],
            ),
          ),
        ],
      ),
    ));
  }

  _buildItem(String title, String id, String imagePath, String backdropPath,
      double itemHeight, bool isFirst) {
    final card = Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10.0,
      margin: EdgeInsets.only(left: isFirst ? 20 : 10, right: 10, bottom: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: itemHeight * 4 / 3,
        height: itemHeight / 2,
      ),
    );
    return GestureDetector(
      child: card,
      onTap: () {
        timeDilation = 1.5;
        // Navigator.pushNamed(context, 'details', arguments: movie);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      MoviesInfoBloc()..add(LoadMoviesInfo(id: id)),
                  child: MoivesInfo(
                    image: backdropPath,
                    title: title,
                  ),
                )));
      },
    );
  }
}
