import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/widget/movie_poster.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';
import '../../themes.dart';

class TvListView extends StatelessWidget{
  final String title;
  final TvModelList tvList;
  TvListView({required this.title, required this.tvList});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                      //Go to all tv shows
                      Get.toNamed(AppRoutes.allTvShow);
                      AllTvShowsController.instance.onInit();

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
                for (var i = 0; i < tvList.movies!.length; i++)
                  MoviePoster(
                      poster: tvList.movies![i].poster!,
                      name: tvList.movies![i].title!,
                      backdrop: tvList.movies![i].backdrop!,
                      date: tvList.movies![i].release_date!,
                      id: tvList.movies![i].id!,
                      color: Get.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      isMovie: false)
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
