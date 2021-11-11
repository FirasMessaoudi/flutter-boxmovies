import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/streams/tv_stream.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/shared/widget/backdrop.dart';

import '../../../themes.dart';

class TvSearchResults extends StatelessWidget {
  final String query;
  final int results;
  const TvSearchResults({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TvSearchResultsWidget(
        query: query,
        results: results,
      ),
    );
  }
}

class TvSearchResultsWidget extends StatefulWidget {
  final String query;
  final int results;

  const TvSearchResultsWidget({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);
  @override
  _TvSearchResultsWidgetState createState() => _TvSearchResultsWidgetState();
}

class _TvSearchResultsWidgetState extends State<TvSearchResultsWidget> {
  GetSearchResultsTv repo = GetSearchResultsTv();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }
  @override
  void didUpdateWidget(TvSearchResultsWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.query != oldWidget.query){
      print('new value '+widget.query+ ' oldValude '+oldWidget.query);
      // repo.movies=[];
      // repo.page = 1;
      // repo.addData(widget.query);
      repo = new  GetSearchResultsTv();
      repo.addData(widget.query);
      // controller.addListener(_scrollListener);
    }
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
                        Responsive.isMobile(context)|| Responsive.isTablet(context)?ListView(
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
                                color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                isMovie: true,
                                rate: 9))
                                .toList()
                          ],
                        ):   GridView(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 28 / 16),
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
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
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
                                style: normalText.copyWith(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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