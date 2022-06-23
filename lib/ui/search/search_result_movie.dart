import 'package:flutter/material.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/streams/movies_stream.dart';
import 'package:moviebox/shared/widget/backdrop.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import '../../themes.dart';

class MovieResultSearchView extends StatefulWidget {
  final String query;

  const MovieResultSearchView({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  _MovieResultSearchViewState createState() => _MovieResultSearchViewState();
}

class _MovieResultSearchViewState extends State<MovieResultSearchView> {
  MoviesResultsSearchStream repo = MoviesResultsSearchStream();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(MovieResultSearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      repo = new MoviesResultsSearchStream();
      repo.addData(widget.query);
    }
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
    return Scaffold(
      body: CustomScrollView(
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
                    print(snapshot.data!.length);
                    // final movies = snapshot.data!;
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
                                            poster: movie.poster??'',
                                            backdrop: movie.backdrop??'',
                                            name: movie.title??'',
                                            date: movie.release_date??'',
                                            id: movie.id!,
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
                                                poster: movie.poster??'',
                                                backdrop: movie.backdrop??'',
                                                name: movie.title??'',
                                                date: movie.release_date??'',
                                                id: movie.id!,
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
      ),
    );
  }
}
