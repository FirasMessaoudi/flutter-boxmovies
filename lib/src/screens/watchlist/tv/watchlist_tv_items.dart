import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/streams/watchlist_stream.dart';
import 'package:moviebox/src/screens/watchlist/tv/tv_list_item.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/widget/empty_poster.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/themes.dart';

import '../../favorite/fav_item.dart';

class WatchlistTvItems extends StatefulWidget {
  final String sortBy;
  const WatchlistTvItems({Key? key, required this.sortBy})
      : super(key: key);

  @override
  _WatchlistTvItemsState createState() => _WatchlistTvItemsState();
}

class _WatchlistTvItemsState extends State<WatchlistTvItems> {
   WatchListStream repo = WatchListStream();
  ScrollController controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    repo.addData(ProfileItems.series,null);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        isLoading = true;
        repo.getNextMovies(ProfileItems.series,null);
        isLoading = false;
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

    return
      RefreshIndicator(child:
      CustomScrollView(
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
                                    .map((movie) => TvListItem(
                                          movie: movie,
                                  sortBy: widget.sortBy,
                                        ))
                                    .toList(),
                              Row(children: [
                                 EmptyPoster(
                                        isMovie: false,
                                        action: ProfileItems.movies),
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
                    return Emptywatchlist(
                        isMovie: false);
                    //return Container();
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                      height: 500,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: redColor,
                      )));
                } else {
                  return Row(children: [
                   EmptyPoster(
                            isMovie: false, action: ProfileItems.movies),
                  ]);
                }
              },
            ),
          ),
        ),
      ],
    ),
          onRefresh:(){
           return Future.delayed(Duration(seconds: 1),
               (){
             setState(() {
              repo = new WatchListStream();
              repo.addData(ProfileItems.series,null);
             });
               }
           );
          }
      )
    ;
  }
}
