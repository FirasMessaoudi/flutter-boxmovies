import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/widget/custom_app_bar.dart';
import 'package:moviebox/shared/widget/drawer.dart';
import 'package:moviebox/shared/widget/drawer/custom_drawer.dart';

import 'package:moviebox/ui/home/home_movies_card.ui.dart';
import 'package:moviebox/ui/home/home_page.controller.dart';
import 'package:moviebox/ui/home/movie_list.dart';
import 'package:moviebox/ui/home/tv_list.dart';
import 'package:wiredash/wiredash.dart';

import '../../themes.dart';

/* EXTERNAL PACKAGES */

class HomepageView extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.black,
          child: const Icon(Icons.feedback, color: Colors.red),
          onPressed: () => {
            Wiredash.of(context)!.show()
          },
        ),
        appBar: PreferredSize(
            preferredSize: Size(Get.width, 50.0),
            child: CustomAppBar()
            ),
        body: Obx(() => controller.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                controller: controller.scrollController,
                child:Column(
                children:[
                  HomeMoviesCards(
                      movies: controller.trendingMovies.value),
                  SizedBox(height: 20),
                  MovieListView(
                    title: 'home.now_playing'.tr,
                    moviesList: controller.now_playing.value,
                  ),
                  SizedBox(height: 20),
                  TvListView(
                    title: 'home.popular_tv'.tr,
                    tvList: controller.popular_tv.value,
                  ),
                  SizedBox(height: 20),
                  TvListView(
                    title: 'home.new_episodes'.tr,
                    tvList: controller.new_episodes.value,
                  ),
                  SizedBox(height: 20),
                  MovieListView(
                    title: 'home.top_rated'.tr,
                    moviesList: controller.top_rated_movies.value,
                  ),
                  SizedBox(height: 20),
                  MovieListView(
                    title: 'home.coming_soon'.tr,
                    moviesList: controller.upcoming_movies.value,
                  )
                ]),
              )),
      drawer: CustomDrawer(),
    );
  }
}
