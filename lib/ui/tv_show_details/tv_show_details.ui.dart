import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/util/fav_type.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/shared/widget/error_page.dart';
import 'package:moviebox/shared/widget/expandable_seasons.dart';
import 'package:moviebox/shared/widget/loading.dart';
import 'package:moviebox/shared/widget/movie_poster.dart';
import 'package:moviebox/shared/widget/sliver_app_bar.dart';
import 'package:moviebox/shared/widget/star_icon.dart';
import 'package:moviebox/shared/widget/trailers_widget.dart';
import 'package:moviebox/ui/cast/cast_list.dart';
import 'package:moviebox/ui/plateforms/networks/network_result.controller.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_details.controller.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_overview.ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes.dart';
import 'about_show.ui.dart';

class TvShowDetailsView extends GetView<TvShowsDetailsController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Obx(()=>
          controller.isLoading.isTrue?Loading(image: controller.image):
          controller.isError.isTrue?ErrorPage():
          Container(
            color: controller.color.value,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverAppBarCast(
                    image: controller.tmdbData.value.backdrops,
                    title: controller.tmdbData.value.title,
                    color: controller.color.value,
                    textColor: controller.textColor.value,
                    id: controller.tmdbData.value.id.toString(),
                    type: FavType.tv,
                    releaseDate: controller.tmdbData.value.date,
                    poster: controller.tmdbData.value.poster,
                    rate: controller.tmdbData.value.rateing,
                    isMovie: false,
                    homePage: controller.tmdbData.value.homepage,
                    genres: getOnlyIds(controller.tmdbData.value.genres)),
                SliverToBoxAdapter(
                  child: IconTheme(
                    data: IconThemeData(
                      color: controller.textColor.value,
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.facebookSquare, size: 40),
                            onPressed: () {
                              launch(controller.sinfo.value.facebook??'');
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.twitterSquare, size: 40),
                            onPressed: () {
                              launch(controller.sinfo.value.twitter??'');
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagramSquare, size: 40),
                            onPressed: () {
                              launch(controller.sinfo.value.instagram??'');
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.imdb, size: 40),
                            onPressed: () {
                              launch(controller.sinfo.value.imdbId??'');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              style: normalText.copyWith(color: controller.textColor.value),
                              children: [
                                ...controller.tmdbData.value.genres
                                    .map(
                                      (genre) => TextSpan(text: "${genre.name}, "),
                                )
                                    .toList()
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: controller.textColor.value),
                              SizedBox(width: 5),
                              Text(
                                convertDate(controller.tmdbData.value.date, Get.locale!.languageCode),
                                style: normalText.copyWith(color: controller.textColor.value),
                              )
                            ],
                          ),
                          SizedBox(height: 10),

                          Row(
                            children: [
                              IconTheme(
                                data: IconThemeData(
                                  color: controller.textColor.value == Colors.white
                                      ? Colors.amber
                                      : Colors.blue,
                                  size: 20,
                                ),
                                child: StarDisplay(
                                  value: ((controller.tmdbData.value.rateing * 5) / 10).round(),
                                ),
                              ),
                              Text(
                                "  " + controller.tmdbData.value.rateing.toString() + "/10",
                                style: normalText.copyWith(
                                  color: controller.textColor.value == Colors.white
                                      ? Colors.amber
                                      : Colors.blue,
                                  letterSpacing: 1.2,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "movie_info.watch_on".tr,
                                style:
                                heading.copyWith(color: controller.textColor.value, fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var i = 0; i < controller.tmdbData.value.networks.length; i++)
                                      new GestureDetector(
                                        onTap: () {
                                          NetworkResultController.instance.initSearch(controller.tmdbData.value.networks[i].id);
                                          Get.toNamed(AppRoutes.plateforms, arguments: controller.tmdbData.value.networks[i].name);

                                        },
                                        child: controller.tmdbData.value.networks[i].id != '2739'
                                            ? CachedNetworkImage(
                                          imageUrl:
                                          'https://www.themoviedb.org/t/p/w92/' +
                                              controller.tmdbData.value.networks[i].logo_path,
                                          fit: BoxFit.cover,
                                        )
                                            : FadeInImage(
                                          placeholder: AssetImage(
                                              'assets/img/no-image.jpg'),
                                          image: AssetImage(
                                              'assets/img/disneyplus.jpg'),
                                          fit: BoxFit.cover,
                                          height: 50.0,
                                          width: 90.0,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
                if (controller.tmdbData.value.overview != '')
                  OverviewWidget(textColor: controller.textColor.value, info: controller.tmdbData.value),
                if (controller.trailers.isNotEmpty)
                  TrailersWidget(
                    textColor: controller.textColor.value,
                    trailers: controller.trailers,
                    backdrops: controller.backdrops,
                    backdrop: controller.tmdbData.value.backdrops,
                  ),
                if (controller.cast.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text("movie_info.cast".tr,
                              style: heading.copyWith(color: controller.textColor.value)),
                        ),
                        CastList(castList: controller.cast, textColor: controller.textColor.value),
                      ],
                    ),
                  ),
                AboutShowWidget(textColor: controller.textColor.value, info: controller.tmdbData.value),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Text("my_list.episodes".tr,
                        style: heading.copyWith(color: controller.textColor.value)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            for (var i = 0; i < this.controller.tmdbData.value.seasons.length; i++)
                              if (this.controller.tmdbData.value.seasons[i].name != 'Specials')
                                ExpandableSeason(
                                  tvName: controller.tmdbData.value.title,
                                  backdrop: controller.tmdbData.value.backdrops,
                                  epRuntime: controller.tmdbData.value.episoderuntime,
                                  tvDate: controller.tmdbData.value.date,
                                  tvRate: controller.tmdbData.value.rateing,
                                  tvImage: controller.tmdbData.value.poster,
                                  tvGenre:
                                  getCatgoryNameFromCatgeoryObject(controller.tmdbData.value.genres),
                                  textColor: controller.textColor.value,
                                  headerBackgroundColor: controller.color.value,
                                  items: [],
                                  tvId: this.controller.tmdbData.value.id,
                                  season: this.controller.tmdbData.value.seasons[i],
                                  isExpanded: false,
                                  expandedIcon: Icon(
                                    Icons.arrow_drop_up,
                                    color: controller.textColor.value != Colors.white
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  collapsedIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: controller.textColor.value != Colors.white
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  header: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      this.controller.tmdbData.value.seasons[i].name,
                                      style: heading.copyWith(color: controller.textColor.value),
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text("movie_info.similar_tv".tr,
                            style: heading.copyWith(color: controller.textColor.value)),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < controller.similar.length; i++)
                              MoviePoster(
                                isMovie: false,
                                id: controller.similar[i].id??'',
                                name: controller.similar[i].title??'',
                                backdrop: controller.similar[i].backdrop??'',
                                poster: controller.similar[i].poster??'',
                                color: controller.textColor.value,
                                date: controller.similar[i].release_date??'',
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 30))
              ],
            ),
          )

          )

      ),
    );
  }
  
}