import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/core/streams/watchlist_stream.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/widget/empty_poster.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/themes.dart';

import '../favorite/fav_item.dart';

class WatchlistItems extends StatefulWidget {
  final ProfileItems type;
  final bool? watched;
  const WatchlistItems({Key? key, required this.type, this.watched}) : super(key: key);
  @override
  _WatchlistItemsState createState() => _WatchlistItemsState();
}

class _WatchlistItemsState extends State<WatchlistItems> {
  final WatchListStream repo = WatchListStream();
  ScrollController controller = ScrollController();
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    repo.addData(widget.type,widget.watched);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        isLoading=true;
        repo.getNextMovies(widget.type,widget.watched);
        isLoading=false;
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
            child: StreamBuilder<List<FavoriteWatchListModel>>(
              stream: repo.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //final movies = snapshot.data!;
                  if (repo.movies.isNotEmpty) {
                    return Container(
                      child: Column(
                        children: [
                          ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (repo.movies.isNotEmpty)
                                ...repo.movies
                                    .map((movie) => FavoriteMovieContainer(
                                          movie: movie,
                                          isFavorite: false,
                                  isMovie: widget.type==ProfileItems.movies?true:false,

                                ))
                                    .toList(),
                              Row(children: [
                                widget.type == ProfileItems.movies
                                    ? EmptyPoster(isMovie: true, action: ProfileItems.movies)
                                    : EmptyPoster(isMovie: false, action: ProfileItems.movies),
                              ])
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (repo.movies.isNotEmpty)
                            if (repo.movies.length > 4)
                              Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  color: redColor,
                                ),
                              )
                        ],
                      ),
                    );
                  } else {
                     return Emptywatchlist(isMovie: widget.type == ProfileItems.movies?true:false);
                    //return Container();
                  }
                } else if(snapshot.connectionState==ConnectionState.waiting) {
                  return Container(
                      height: 500,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: redColor,
                      )));
                }else{

                     return Row(children: [
                        widget.type == ProfileItems.movies
                            ? EmptyPoster(isMovie: true, action: ProfileItems.movies)
                            : EmptyPoster(isMovie: false, action: ProfileItems.movies),
                      ]);
                }
              },
            ),
          ),
        ),

      ],
    );
  }
}