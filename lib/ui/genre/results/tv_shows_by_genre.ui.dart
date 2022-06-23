import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/shared/widget/backdrop.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/themes.dart';
import 'package:moviebox/ui/genre/results/tv_shows_by_genre.controller.dart';

class TvShowsByGenreView extends GetView<TvShowsByGenreController> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller.scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<TvModel>>(
              stream: controller.repo.controller.stream,
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
                            ...controller.repo.tvshows
                                .map((movie) => new BackdropPoster(
                                poster: movie.poster!,
                                backdrop: movie.backdrop!,
                                name: movie.title!,
                                date: movie.release_date!,
                                id: movie.id!,
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
                            ...controller.repo.tvshows
                                .map((movie) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new BackdropPoster(
                                    poster: movie.poster!,
                                    backdrop: movie.backdrop!,
                                    name: movie.title!,
                                    date: movie.release_date!,
                                    id: movie.id!,
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
                        if (!controller.repo.isfinish)
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
