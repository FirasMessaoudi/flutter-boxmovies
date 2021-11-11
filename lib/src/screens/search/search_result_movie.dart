import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/streams/movies_stream.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/shared/widget/backdrop.dart';

import '../../../themes.dart';

class SearchResultsMovie extends StatelessWidget {
  final String query;
  final int count;
  const SearchResultsMovie({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MovieResultWidget(
        count: count,
        query: query,
      ),
    );
  }
}

class MovieResultWidget extends StatefulWidget {
  final String query;
  final int count;
  const MovieResultWidget({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);
  @override
  _MovieResultWidgetState createState() => _MovieResultWidgetState();
}

class _MovieResultWidgetState extends State<MovieResultWidget> {
  GetSearchResults repo = GetSearchResults();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    print('movie search');
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(MovieResultWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.query != oldWidget.query){
      print('new value '+widget.query+ ' oldValude '+oldWidget.query);
      // repo.movies=[];
      // repo.page = 1;
      // repo.addData(widget.query);
      repo = new  GetSearchResults();
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
    print('building widget');
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
                  print(snapshot.data!.length);
                  // final movies = snapshot.data!;
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
                            ...repo.movies
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

                            ...repo.movies
                                .map((movie) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new BackdropPoster(
                                    poster: movie.poster,
                                    backdrop: movie.backdrop,
                                    name: movie.title,
                                    date: movie.release_date,
                                    id: movie.id,
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
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
                                style: normalText.copyWith(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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
