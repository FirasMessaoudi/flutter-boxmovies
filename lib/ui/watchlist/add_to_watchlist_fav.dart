import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/streams/movies_stream.dart';
import 'package:moviebox/core/streams/tv_stream.dart';
import 'package:moviebox/shared/util/fav_type.dart';
import 'package:moviebox/shared/util/profile_list_items.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/shared/widget/favorite_button/cubit/fav_cubit.dart';
import 'package:moviebox/shared/widget/favorite_button/fav_button.dart';
import 'package:moviebox/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/shared/widget/watchlist_button/widget/watchlist_icon.dart';

import '../../themes.dart';

class AddToLWatchlistFav extends StatefulWidget {
  final bool isMovie;
  final ProfileItems action;

  const AddToLWatchlistFav({Key? key, required this.isMovie, required this.action})
      : super(key: key);

  @override
  State<AddToLWatchlistFav> createState() => _AddToLWatchlistFavState();
}

class _AddToLWatchlistFavState extends State<AddToLWatchlistFav> {
  MoviesResultsSearchStream repo = MoviesResultsSearchStream();
  TvShowsResultSearchStream repoTv = TvShowsResultSearchStream();
  ScrollController controller = ScrollController();
  String query = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isMovie)
      repo.addData(query);
    else
      repoTv.addData(query);
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    repo.dispose();
    repoTv.dispose();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        if (widget.isMovie)
          repo.getNextMovies(query);
        else
          repoTv.getNextMovies(query);
        print("at the end of list");
      }
    }
  }

  void search() async {
    if (widget.isMovie) {
      repo = new MoviesResultsSearchStream();
      repo.addData(query);
    } else {
      repoTv = new TvShowsResultSearchStream();
      repoTv.addData(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.isMovie ? 'my_list.movies'.tr : 'my_list.shows'.tr),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: TextField(
            style: normalText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: 'discover.search'.tr,
                hintStyle: normalText,
                // fillColor: Colors.black,
                filled: true,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                )),
            onChanged: (value) => {
              query = value,
              setState(() {
                search();
              })
            },
          ),
        ),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: widget.isMovie
                ? Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 3.0, vertical: 10.0),
              child: StreamBuilder<List<MovieModel>>(
                stream: repo.controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.length);
                    // final movies = snapshot.data!;
                    return Container(
                      child: Column(
                        children: [
                          ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: repo.movies.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    onTap: () {
                                      moveToInfo(
                                          context,
                                          true,
                                          repo.movies[index].id!,
                                          repo.movies[index].backdrop!,
                                          repo.movies[index].title!);
                                    },
                                    leading: Image.network(
                                        repo.movies[index].poster!),
                                    title: Text(repo.movies[index].title!),
                                    trailing: widget.action ==
                                        ProfileItems.fav
                                        ? BlocProvider(
                                      create: (context) =>
                                      FavMovieCubit()
                                        ..init(repo
                                            .movies[index].id!),
                                      child: FavIcon(
                                          type: FavType.movie,
                                          title: repo
                                              .movies[index].title!,
                                          movieid:
                                                          repo.movies[index].id!,
                                                      poster: repo
                                                          .movies[index].poster!,
                                                      date: repo.movies[index]
                                                          .release_date!,
                                                      rate: repo.movies[index]
                                                          .vote_average!,
                                                      color: redColor,
                                                      isEpisode: true,
                                                      age: '',
                                                      genres: repo
                                                          .movies[index].genres,
                                                      backdrop: repo
                                                          .movies[index]
                                                          .backdrop!),
                                    )
                                        : BlocProvider(
                                        create: (context) =>
                                                      WatchlistCubit()
                                                        ..init(
                                                            repo.movies[index]
                                                                .id!,
                                                            true),
                                                  child: WatchListIcon(
                                                      justIcon: true,
                                                      movieid:
                                                          repo.movies[index].id!,
                                                      title: repo
                                                          .movies[index].title!,
                                                      poster: repo
                                                          .movies[index].poster!,
                                                      date: repo.movies[index]
                                                          .release_date!,
                                                      rate: repo.movies[index]
                                                          .vote_average!,
                                                      isMovie: true,
                                                      color: Colors.white,
                                                      genres: repo
                                                          .movies[index].genres,
                                                      backdrop: repo
                                                          .movies[index]
                                                          .backdrop!)));
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black45);
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          if (!repo.isfinish)
                            Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  color: redColor,
                                ))
                          else
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Look like you reach the end!",
                                  style: normalText.copyWith(
                                      color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          color: redColor,
                        ));
                  }
                },
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 3.0, vertical: 10.0),
              child: StreamBuilder<List<TvModel>>(
                stream: repoTv.controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.length);
                    // final movies = snapshot.data!;
                    return Container(
                      child: Column(
                        children: [
                          ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: repoTv.tvshows.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    onTap: () {
                                      moveToInfo(
                                          context,
                                          false,
                                          repoTv.tvshows[index].id!,
                                          repoTv.tvshows[index].backdrop!,
                                          repoTv.tvshows[index].title!);
                                    },
                                    leading: Image.network(
                                        repoTv.tvshows[index].poster!),
                                    title:
                                    Text(repoTv.tvshows[index].title!),
                                    trailing:
                                    widget.action == ProfileItems.fav
                                        ? BlocProvider(
                                      create: (context) =>
                                      FavMovieCubit()
                                        ..init(repoTv
                                            .tvshows[index]
                                            .id!),
                                      child: FavIcon(
                                          type: FavType.tv,
                                          title: repoTv
                                              .tvshows[index]
                                              .title!,
                                          movieid: repoTv
                                              .tvshows[index]
                                              .id!,
                                          poster: repoTv
                                              .tvshows[index]
                                                          .poster!,
                                                      date: repoTv
                                                          .tvshows[index]
                                                          .release_date!,
                                                      rate: repoTv
                                                          .tvshows[index]
                                                          .vote_average!,
                                                      color: redColor,
                                                      isEpisode: true,
                                                      age: '',
                                                      genres: repoTv
                                                          .tvshows[index]
                                                          .genres,
                                                      backdrop: repoTv
                                                          .tvshows[index]
                                                          .backdrop!),
                                    )
                                        : BlocProvider(
                                        create: (context) =>
                                                      WatchlistCubit()
                                                        ..init(
                                                            repoTv
                                                                .tvshows[index]
                                                                .id!,
                                                            false),
                                                  child: WatchListIcon(
                                                    movieid: repoTv
                                                        .tvshows[index].id!,
                                                    title: repoTv
                                                        .tvshows[index].title!,
                                                    poster: repoTv
                                                        .tvshows[index].poster!,
                                                    backdrop: repoTv
                                                        .tvshows[index]
                                                        .backdrop!,
                                                    date: repoTv.tvshows[index]
                                                        .release_date!,
                                                    rate: repoTv.tvshows[index]
                                                        .vote_average!,
                                                    isMovie: false,
                                                    genres: repoTv
                                                        .tvshows[index].genres,
                                                    color: Colors.white,
                                                    justIcon: true,
                                                  )));
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black45);
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          if (!repoTv.isfinish)
                            Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  color: redColor,
                                ))
                          else
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Look like you reach the end!",
                                  style: normalText.copyWith(
                                      color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          color: redColor,
                        ));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
