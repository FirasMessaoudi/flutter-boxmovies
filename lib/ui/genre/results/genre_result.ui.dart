import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/ui/genre/results/movies_by_genre.controller.dart';
import 'package:moviebox/ui/genre/results/movies_by_genre.ui.dart';
import 'package:moviebox/ui/genre/results/tv_shows_by_genre.ui.dart';

import '../../../themes.dart';

class GenreResultView extends GetView<MoviesByGenreController> {


  const GenreResultView(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.dark,
              title: Text(controller.title, style: heading.copyWith(color: Colors.white)),
              bottom: TabBar(
                indicatorColor: redColor,
                labelStyle: normalText.copyWith(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black),
                labelColor: Get.isDarkMode
                    ? Colors.white
                    : Colors.black,
                labelPadding: EdgeInsets.only(top: 10.0),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'home.movies'.tr,
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'home.series'.tr,
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MoviesByGenreView(
                ),
                TvShowsByGenreView(
                ),
              ],
            ),
          )),
    );
  }
}





