import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moviebox/shared/util/fav_type.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/shared/widget/error_page.dart';
import 'package:moviebox/shared/widget/expandable.dart';
import 'package:moviebox/shared/widget/loading.dart';
import 'package:moviebox/shared/widget/movie_poster.dart';
import 'package:moviebox/shared/widget/sliver_app_bar.dart';
import 'package:moviebox/shared/widget/star_icon.dart';
import 'package:moviebox/shared/widget/trailers_widget.dart';
import 'package:moviebox/ui/cast/cast_list.dart';
import 'package:moviebox/ui/movies_details/movies_details.controller.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes.dart';

class MoviesDetailsView extends GetView<MoviesDetailsController>{
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
                        image: controller.tmdbData.value.backdrops!,
                        title: controller.tmdbData.value.title!,
                        color: controller.color.value,
                        textColor: controller.textColor.value,
                        id: controller.tmdbData.value.tmdbId??'',
                        type: FavType.movie,
                        poster: controller.tmdbData.value.poster??'',
                        releaseDate: controller.tmdbData.value.dateByMonth??'',
                        homePage: controller.tmdbData.value.homepage,
                        trailer: controller.trailers[0].key,
                        rate: controller.tmdbData.value.rateing??0,
                        isMovie: true,
                        genres: getOnlyIds(controller.tmdbData.value.genres??[])),
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
                                    ...controller.tmdbData.value.genres!
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
                                    convertDate(
                                        controller.tmdbData.value.releaseDate??'', Get.locale!.languageCode),
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
                                      value: ((controller.tmdbData.value.rateing??0 * 5) / 10).round(),
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
                            ],
                          )),
                    ),
                    if (controller.tmdbData.value.overview != '')
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("movie_info.overview".tr,
                                  style: heading.copyWith(color: controller.textColor.value)),
                              SizedBox(height: 10),
                              ReadMoreText(
                                controller.tmdbData.value.overview??'',
                                trimLines: 6,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'movie_info.show_more'.tr,
                                trimExpandedText: 'movie_info.show_less'.tr,
                                style: normalText.copyWith(
                                    fontWeight: FontWeight.w500, color: controller.textColor.value),
                                moreStyle:
                                TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (controller.trailers.isNotEmpty)
                      TrailersWidget(
                        textColor: controller.textColor.value,
                        trailers: controller.trailers,
                        backdrops: controller.backdrops,
                        backdrop: controller.tmdbData.value.backdrops??'',
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
                    SliverToBoxAdapter(
                      child: ExpandableGroup(
                        isExpanded: true,
                        expandedIcon: Icon(
                          Icons.arrow_drop_up,
                          color: controller.textColor.value != Colors.white ? Colors.black : Colors.white,
                        ),
                        collapsedIcon: Icon(
                          Icons.arrow_drop_down,
                          color: controller.textColor.value != Colors.white ? Colors.black : Colors.white,
                        ),
                        header: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "movie_info.about_movie".tr,
                            style: heading.copyWith(color: controller.textColor.value),
                          ),
                        ),
                        items: [
                          if (controller.tmdbData.value.tagline != '')
                            ListTile(
                                title: Text(
                                  "movie_info.tagline_movie".tr,
                                  style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                                ),
                                subtitle: Text(
                                  controller.tmdbData.value.tagline??'',
                                  style: normalText.copyWith(color: controller.textColor.value),
                                )),
                          ListTile(
                              title: Text(
                                "movie_info.runtime".tr,
                                style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                              ),
                              subtitle: Text(
                                controller.imdbData.value.runtime??'',
                                style: normalText.copyWith(color: controller.textColor.value),
                              )),
                          ListTile(
                              title: Text(
                                "movie_info.writers".tr,
                                style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                              ),
                              subtitle: Text(
                                controller.imdbData.value.writer??'',
                                style: normalText.copyWith(color: controller.textColor.value),
                              )),
                          ListTile(
                              title: Text(
                                "movie_info.director".tr,
                                style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                              ),
                              subtitle: Text(
                                controller.imdbData.value.director??'',
                                style: normalText.copyWith(color: controller.textColor.value),
                              )),
                          ListTile(
                              title: Text(
                                "movie_info.released_movie".tr,
                                style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                              ),
                              subtitle: Text(
                                convertDate(
                                    controller.tmdbData.value.releaseDate??'', Get.locale!.languageCode),
                                style: normalText.copyWith(color: controller.textColor.value),
                              )),
                          ListTile(
                              title: Text(
                                "movie_info.rating".tr,
                                style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                              ),
                              subtitle: Text(
                                controller.imdbData.value.rated??'',
                                style: normalText.copyWith(color: controller.textColor.value),
                              )),
                          ListTile(
                              title: Text(
                                "BoxOffice",
                                style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                              ),
                              subtitle: Text(
                                controller.formattedCurrency(),
                                style: normalText.copyWith(color: controller.textColor.value),
                              )),
                        ],
                      ),
                    ),
                    if (controller.similar.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text("movie_info.similar_movie".tr,
                                  style: heading.copyWith(color: controller.textColor.value)),
                            ),
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var i = 0; i < controller.similar.length; i++)
                                    MoviePoster(
                                        poster: controller.similar[i].poster??'',
                                        name:  controller.similar[i].title??'',
                                        backdrop:  controller.similar[i].backdrop??'',
                                        date:  controller.similar[i].release_date??'',
                                        id:  controller.similar[i].id??'',
                                        color: controller.textColor.value,
                                        isMovie: true)
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

