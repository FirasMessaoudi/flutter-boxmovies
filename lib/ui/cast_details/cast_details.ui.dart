import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moviebox/shared/util/fav_type.dart';
import 'package:moviebox/shared/widget/error_page.dart';
import 'package:moviebox/shared/widget/image_view.dart';
import 'package:moviebox/shared/widget/loading.dart';
import 'package:moviebox/shared/widget/movie_poster.dart';
import 'package:moviebox/shared/widget/sliver_app_bar.dart';
import 'package:moviebox/ui/cast_details/cast_details.controller.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes.dart';

class CastDetailsView extends GetView<CastDetailsController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
        Obx(()=>
        controller.isLoading.isTrue?LoadingCast(
          image: controller.args['image'],
          title: controller.args['title'],
        ):controller.isError.isTrue?ErrorPage():Container(
          color: controller.color.value,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              SliverAppBarCast(
                  color: controller.color.value,
                  textColor: controller.textColor.value,
                  title: controller.info.value.name??'',
                  image: controller.args['image'],
                  id: controller.info.value.id??'',
                  type: FavType.person,
                  poster: controller.info.value.image??'',
                  age: controller.info.value.old??'',
                  isActor: true),
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
                        if (controller.socialInfo.value.facebook != "")
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.facebookSquare, size: 40),
                            onPressed: () {
                              launch(controller.socialInfo.value.facebook??'');
                            },
                          ),
                        if (controller.socialInfo.value.twitter != "")
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.twitterSquare, size: 40),
                            onPressed: () {
                              launch(controller.socialInfo.value.twitter??'');
                            },
                          ),
                        if (controller.socialInfo.value.instagram != "")
                          IconButton(
                            icon:
                            FaIcon(FontAwesomeIcons.instagramSquare, size: 40),
                            onPressed: () {
                              launch(controller.socialInfo.value.instagram??'');
                            },
                          ),
                        if (controller.socialInfo.value.imdbId != "")
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.imdb, size: 40),
                            onPressed: () {
                              launch(controller.socialInfo.value.imdbId??'');
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "cast.info".tr,
                          style: heading.copyWith(color: controller.textColor.value, fontSize: 22),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "cast.known_for".tr,
                                      style: heading.copyWith(
                                          color: controller.textColor.value, fontSize: 16),
                                    ),
                                    Text(controller.info.value.knownfor??'',
                                        style: normalText.copyWith(
                                          color: controller.textColor.value,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "cast.gender".tr,
                                    style: heading.copyWith(
                                        color: controller.textColor.value, fontSize: 16),
                                  ),
                                  Text(controller.info.value.gender??'',
                                      style: normalText.copyWith(
                                        color: controller.textColor.value,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "edit_profile.birthdate".tr,
                              style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                            ),
                            Text(controller.info.value.birthday??'' + " (${controller.info.value.old})",
                                style: normalText.copyWith(
                                  color: controller.textColor.value,
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "cast.birthplace".tr,
                              style: heading.copyWith(color: controller.textColor.value, fontSize: 16),
                            ),
                            Text(controller.info.value.placeOfBirth??'',
                                style: normalText.copyWith(
                                  color: controller.textColor.value,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )),
              if (controller.images.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text("cast.image_of".tr + controller.info.value.name!,
                            style: heading.copyWith(color: controller.textColor.value)),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < controller.images.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewPhotos(
                                          imageList: controller.images,
                                          imageIndex: i,
                                          color: controller.color.value,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    color: Colors.black,
                                    width: 130,
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: controller.images[i].image??''),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.info.value.bio != "")
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "cast.bio".tr,
                          style: heading.copyWith(
                            color: controller.textColor.value,
                          ),
                        ),
                        SizedBox(height: 10),
                        ReadMoreText(
                          controller.info.value.bio??'',
                          trimLines: 10,
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
              if (controller.movies.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text("home.movies".tr,
                            style: heading.copyWith(color: controller.textColor.value)),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < controller.movies.length; i++)
                              MoviePoster(
                                  poster: controller.movies[i].poster??'',
                                  name: controller.movies[i].title??'',
                                  backdrop: controller.movies[i].backdrop??'',
                                  date: controller.movies[i].release_date??'',
                                  id: controller.movies[i].id??'',
                                  color: controller.textColor.value,
                                  isMovie: true)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.movies.isNotEmpty)
                SliverToBoxAdapter(child: SizedBox(height: 10)),
              if (controller.tvShows.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text("home.series".tr,
                            style: heading.copyWith(color: controller.textColor.value)),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < controller.tvShows.length; i++)
                              MoviePoster(
                                  poster: controller.tvShows[i].poster??'',
                                  name: controller.tvShows[i].title??'',
                                  backdrop: controller.tvShows[i].backdrop??'',
                                  date: controller.tvShows[i].release_date??'',
                                  id: controller.tvShows[i].id??'',
                                  color: controller.textColor.value,
                                  isMovie: false)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.tvShows.isNotEmpty) SliverToBoxAdapter(child: SizedBox(height: 30))
            ],
          ),
        )
        )
    ));
  }

}