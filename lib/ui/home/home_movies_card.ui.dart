import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/shared/widget/content_header.dart';

class HomeMoviesCards extends StatelessWidget{
  final MovieModelList movies;

  const HomeMoviesCards({Key? key, required this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    movies.movies!.shuffle();
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 500,
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
                      i < movies.movies!.length;
                      i++)
                        Center(
                            child: ContentHeader(
                                featuredContent:
                               movies.movies![i])),
                    ],
                  ))
            ]));
  }

}