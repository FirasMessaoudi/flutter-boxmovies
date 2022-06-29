import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/widget/movie_poster.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';
import '../../themes.dart';

class MovieListView extends StatelessWidget {
  final String title;
  final MovieModelList moviesList;
  MovieListView({Key? key,
    required this.title,
    required  this.moviesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: heading.copyWith(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      GestureDetector(
                        onTap: () {
                         //go to all movies
                          Get.toNamed(AppRoutes.allMovies);
                          AllMoviesController.instance.onInit();
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "home.see_all".tr,
                                style: normalText.copyWith(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black)),
                            WidgetSpan(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ))
                          ]),
                        ),
                      )
                    ],
                  )),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 7),
                    for (var i = 0; i < moviesList.movies!.length; i++)
                      MoviePoster(
                          poster: moviesList.movies![i].poster!,
                          name: moviesList.movies![i].title!,
                          backdrop: moviesList.movies![i].backdrop!,
                          date: moviesList.movies![i].release_date!,
                          id: moviesList.movies![i].id!,
                          color: Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          isMovie: true)
                  ],
                ),
              ),
            ],
          ),
        ));
  }

}
