import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/responsive/app_bar_cubit.dart';
import 'package:moviebox/src/responsive/content_header.dart';
import 'package:moviebox/src/responsive/custom_app_bar.dart';
import 'package:moviebox/src/screens/home/movie_list.dart';
import 'package:moviebox/src/screens/home/tv_list.dart';
import 'package:moviebox/src/shared/util/movie_type.dart';
import 'package:wiredash/wiredash.dart';

import '../../../themes.dart';

/* EXTERNAL PACKAGES */

class Homepage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Homepage({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final moviesProvider = new MoviesRepo();
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollController.offset);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          child: const Icon(Icons.feedback, color: Colors.red),
          onPressed: () => {

           Wiredash.of(context)!.show()

          },
        ),
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 50.0),
          child: BlocBuilder<AppBarCubit, double>(
            builder: (context, scrollOffset) {
              return CustomAppBar(
                  scrollOffset: scrollOffset, scaffoldKey: widget.scaffoldKey);
            },
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _swiperCards(),
            ),
            SliverToBoxAdapter(
              child: MovieListView(
                program: MovieListType.movie,
                type: MovieListType.trendingMovie,
                title: 'home.now_playing'.tr(),
                onItemInteraction: (movieId, img) {
                  _navigateToMovieDetail(
                      context, MovieListType.tv, movieId, img);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: TvListView(
                type: MovieListType.trendingTv,
                title: 'home.popular_tv'.tr(),
                onItemInteraction: (movieId, img) {
                  _navigateToMovieDetail(
                      context, MovieListType.trendingTv, movieId, img);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: TvListView(
                type: MovieListType.newTv,
                title: 'home.new_episodes'.tr(),
                onItemInteraction: (movieId, img) {
                  _navigateToMovieDetail(
                      context, MovieListType.newTv, movieId, img);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: MovieListView(
                program: MovieListType.movie,
                type: MovieListType.topRated,
                title: 'home.top_rated'.tr(),
                onItemInteraction: (movieId, img) {
                  _navigateToMovieDetail(
                      context, MovieListType.tv, movieId, img);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: MovieListView(
                program: MovieListType.movie,
                type: MovieListType.upcoming,
                title: 'home.coming_soon'.tr(),
                onItemInteraction: (movieId, img) {
                  _navigateToMovieDetail(
                      context, MovieListType.tv, movieId, img);
                },
              ),
            )
          ],
        )
        // Container(
        //  child: ScrollConfiguration(
        //    behavior: MyScrollBehavior(),
        //    child: SingleChildScrollView(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[

        //         _swiperCards(),
        //         Padding(padding: EdgeInsets.only(top: 10)),
        //         // MovieCategory()
        //         _buildMyList(context)],
        //   ),
        // ),
        //  ),
        // ),

        );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getMovies(),
      builder: (BuildContext context, AsyncSnapshot<MovieModelList> snapshot) {
        if (snapshot.hasData) {
          snapshot..data!.movies.shuffle();
          // return CardSwiper(movies: snapshot.data!.movies);
          return SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 550,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          dragStartBehavior: DragStartBehavior.start,
                          physics: BouncingScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          children: [
                            for (var i = 0;
                                i < snapshot.data!.movies.length;
                                i++)
                              Center(
                                  child: ContentHeader(
                                      featuredContent:
                                          snapshot.data!.movies[i])),
                          ],
                        ))
                  ]));
        } else {
          print('no data yest');
          return Container(
            height: 500.0,
            child: Center(
                child: CircularProgressIndicator(
              color: redColor,
            )),
          );
        }
      },
    );
  }

  Widget _buildMyList(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          MovieListView(
            program: MovieListType.movie,
            type: MovieListType.trendingMovie,
            title: 'home.now_playing'.tr(),
            onItemInteraction: (movieId, img) {
              _navigateToMovieDetail(context, MovieListType.tv, movieId, img);
            },
          ),
          TvListView(
            type: MovieListType.newTv,
            title: 'home.new_episodes'.tr(),
            onItemInteraction: (movieId, img) {
              _navigateToMovieDetail(
                  context, MovieListType.newTv, movieId, img);
            },
          ),
          TvListView(
            type: MovieListType.trendingTv,
            title: 'home.popular_tv'.tr(),
            onItemInteraction: (movieId, img) {
              _navigateToMovieDetail(
                  context, MovieListType.trendingTv, movieId, img);
            },
          ),
          MovieListView(
            program: MovieListType.movie,
            type: MovieListType.upcoming,
            title: 'home.coming_soon'.tr(),
            onItemInteraction: (movieId, img) {
              _navigateToMovieDetail(context, MovieListType.tv, movieId, img);
            },
          ),
        ],
      ),
    );
  }

  _navigateToMovieDetail(
      BuildContext context, String program, int movieId, String img) {}
}
