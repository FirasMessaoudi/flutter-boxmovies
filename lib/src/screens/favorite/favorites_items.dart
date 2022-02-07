import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/streams/favorites_stream.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/widget/empty_poster.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/themes.dart';

import 'fav_item.dart';

class FavoritesItems extends StatefulWidget {
  final FavType type;

  const FavoritesItems({Key? key, required this.type}) : super(key: key);

  @override
  _FavoritesItemsState createState() => _FavoritesItemsState();
}

class _FavoritesItemsState extends State<FavoritesItems> {
  final FavoritesStream repo = FavoritesStream();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.type);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(widget.type);
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
                       !Responsive.isDesktop(context) || (widget.type!=FavType.person && widget.type!=FavType.episode)?
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
                                          isFavorite: true,
                                          isEpisode:
                                              widget.type == FavType.episode
                                                  ? true
                                                  : false,
                                          isActor: widget.type == FavType.person
                                              ? true
                                              : false,
                                          isMovie: widget.type == FavType.movie
                                              ? true
                                              : false,
                                        ))
                                    .toList(),
                            ],
                          ):
                       GridView(
                         gridDelegate:
                         SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: widget.type==FavType.person?4:3,
                         ),
                         physics: BouncingScrollPhysics(),
                         shrinkWrap: true,
                         children: [
                           if (repo.movies.isNotEmpty)
                             ...repo.movies
                                 .map((movie) => FavoriteMovieContainer(
                               movie: movie,
                               isFavorite: true,
                               isEpisode:
                               widget.type == FavType.episode
                                   ? true
                                   : false,
                               isActor: widget.type == FavType.person
                                   ? true
                                   : false,
                               isMovie: widget.type == FavType.movie
                                   ? true
                                   : false,
                             ))
                                 .toList(),
                         ],
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
                    return EmptyFavorites(
                        isMovie: widget.type == FavType.movie ? true : false,
                        type: widget.type);
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
