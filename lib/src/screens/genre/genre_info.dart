import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/streams/genre_movies.dart';
import 'package:moviebox/src/core/streams/genre_tv.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/shared/widget/backdrop.dart';

import '../../../themes.dart';

class GenreInfo extends StatelessWidget {
  final String id;
  final String idTv;
  final String title;

  const GenreInfo(
      {Key? key, required this.id, required this.title, required this.idTv})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.dark,
              title: Text(title, style: heading.copyWith(color: Colors.white)),
              bottom: TabBar(
                indicatorColor: redColor,
                labelStyle: normalText.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
                labelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                labelPadding: EdgeInsets.only(top: 10.0),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'home.movies'.tr(),
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'home.series'.tr(),
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SearchResults(
                  query: id.toString(),
                  count: 100,
                ),
                SearchResultsTv(
                  results: 200,
                  query: idTv.toString(),
                ),
              ],
            ),
          )),
    );
  }
}

class SearchResults extends StatelessWidget {
  final String query;
  final int count;

  const SearchResults({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MoviesGenreWidget(
        count: count,
        query: query,
      ),
    );
  }
}

class MoviesGenreWidget extends StatefulWidget {
  final String query;
  final int count;

  const MoviesGenreWidget({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);

  @override
  _MoviesGenreWidgetState createState() => _MoviesGenreWidgetState();
}

class _MoviesGenreWidgetState extends State<MoviesGenreWidget> {
  final GenreMovies repo = GenreMovies();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(widget.query);
        print("at the end of list");
      }
    }
  }

  @override
  void dispose() {
    repo.dispose();
    repo.controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<MovieModel>>(
              stream: repo.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: [
                        Responsive.isMobile(context) ||
                                Responsive.isTablet(context)
                            ? ListView(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ...repo.movies
                                      .map((movie) => new BackdropPoster(
                                          poster: movie.poster,
                                          backdrop: movie.backdrop,
                                          name: movie.title,
                                          date: movie.release_date,
                                          id: movie.id,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          isMovie: true,
                                          rate: 9))
                                      .toList()
                                ],
                              )
                            : GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 28 / 16),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  ...repo.movies
                                      .map((movie) => Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: new BackdropPoster(
                                              poster: movie.poster,
                                              backdrop: movie.backdrop,
                                              name: movie.title,
                                              date: movie.release_date,
                                              id: movie.id,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              isMovie: true,
                                              rate: 9)))
                                      .toList()
                                ],
                              ),
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
                                    color: Theme.of(context).brightness ==
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
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SearchResultsTv extends StatelessWidget {
  final String query;
  final int results;

  const SearchResultsTv({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MoviesGenreTvWidget(
        query: query,
        results: results,
      ),
    );
  }
}

class MoviesGenreTvWidget extends StatefulWidget {
  final String query;
  final int results;

  const MoviesGenreTvWidget({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);

  @override
  _MoviesGenreTvWidgetState createState() => _MoviesGenreTvWidgetState();
}

class _MoviesGenreTvWidgetState extends State<MoviesGenreTvWidget> {
  final GenreTv repo = GenreTv();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(widget.query);
      }
    }
  }

  @override
  void dispose() {
    repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<TvModel>>(
              stream: repo.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: [
                        Responsive.isMobile(context) ||
                                Responsive.isTablet(context)
                            ? ListView(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ...repo.tvshows
                                      .map((movie) => new BackdropPoster(
                                          poster: movie.poster,
                                          backdrop: movie.backdrop,
                                          name: movie.title,
                                          date: movie.release_date,
                                          id: movie.id,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          isMovie: false,
                                          rate: 9))
                                      .toList()
                                ],
                              )
                            : GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 28 / 16),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  ...repo.tvshows
                                      .map((movie) => Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: new BackdropPoster(
                                              poster: movie.poster,
                                              backdrop: movie.backdrop,
                                              name: movie.title,
                                              date: movie.release_date,
                                              id: movie.id,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              isMovie: false,
                                              rate: 9)))
                                      .toList()
                                ],
                              ),
                        SizedBox(
                          height: 20,
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
