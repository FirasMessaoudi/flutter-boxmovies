import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_state.dart';
import 'package:moviebox/src/core/model/cast_info.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/src/shared/widget/image_view.dart';
import 'package:moviebox/src/shared/widget/loading.dart';
import 'package:moviebox/src/shared/widget/movie_poster.dart';
import 'package:moviebox/src/shared/widget/sliver_app_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../themes.dart';

class CastPersonalInfoScreen extends StatelessWidget {
  final String image;
  final String title;

  const CastPersonalInfoScreen({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<CastMoviesBloc, CastMoviesState>(
          builder: (context, state) {
            if (state is CastMoviesLoading) {
              return LoadingCast(
                image: image,
                title: title,
              );
            } else if (state is CastMoviesLoaded) {
              return CastInfoLoaded(
                color: state.color,
                movies: state.movies,
                backgroundImage: image,
                tv: state.tvShows,
                info: state.info,
                images: state.images,
                sinfo: state.socialInfo,
                textColor: state.textColor,
              );
            } else if (state is CastMoviesError) {
              return ErrorPage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class CastInfoLoaded extends StatelessWidget {
  final CastPersonalInfo info;
  final String backgroundImage;
  final Color color;
  final List<TvModel> tv;
  final Color textColor;
  final SocialMediaInfo sinfo;
  final List<MovieModel> movies;
  final List<ImageBackdrop> images;

  const CastInfoLoaded({
    Key? key,
    required this.info,
    required this.backgroundImage,
    required this.color,
    required this.tv,
    required this.textColor,
    required this.sinfo,
    required this.movies,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBarCast(
              color: color,
              textColor: textColor,
              title: info.name,
              image: backgroundImage,
              id: info.id,
              type: FavType.person,
              poster: info.image,
              age: info.old,
              isActor: true),
          SliverToBoxAdapter(
            child: IconTheme(
              data: IconThemeData(
                color: textColor,
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (sinfo.facebook != "")
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebookSquare, size: 40),
                        onPressed: () {
                          launch(sinfo.facebook);
                        },
                      ),
                    if (sinfo.twitter != "")
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.twitterSquare, size: 40),
                        onPressed: () {
                          launch(sinfo.twitter);
                        },
                      ),
                    if (sinfo.instagram != "")
                      IconButton(
                        icon:
                            FaIcon(FontAwesomeIcons.instagramSquare, size: 40),
                        onPressed: () {
                          launch(sinfo.instagram);
                        },
                      ),
                    if (sinfo.imdbId != "")
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.imdb, size: 40),
                        onPressed: () {
                          launch(sinfo.imdbId);
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
                  "cast.info".tr(),
                  style: heading.copyWith(color: textColor, fontSize: 22),
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
                              "cast.known_for".tr(),
                              style: heading.copyWith(
                                  color: textColor, fontSize: 16),
                            ),
                            Text(info.knownfor,
                                style: normalText.copyWith(
                                  color: textColor,
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
                            "cast.gender".tr(),
                            style: heading.copyWith(
                                color: textColor, fontSize: 16),
                          ),
                          Text(info.gender,
                              style: normalText.copyWith(
                                color: textColor,
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
                      "edit_profile.birthdate".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    Text(info.birthday + " (${info.old})",
                        style: normalText.copyWith(
                          color: textColor,
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "cast.birthplace".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    Text(info.placeOfBirth,
                        style: normalText.copyWith(
                          color: textColor,
                        )),
                  ],
                ),
              ],
            ),
          )),
          if (images.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("cast.image_of".tr() + info.name,
                        style: heading.copyWith(color: textColor)),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < images.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewPhotos(
                                      imageList: images,
                                      imageIndex: i,
                                      color: color,
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
                                    imageUrl: images[i].image),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (info.bio != "")
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "cast.bio".tr(),
                      style: heading.copyWith(
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    ReadMoreText(
                      info.bio,
                      trimLines: 10,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'movie_info.show_more'.tr(),
                      trimExpandedText: 'movie_info.show_less'.tr(),
                      style: normalText.copyWith(
                          fontWeight: FontWeight.w500, color: textColor),
                      moreStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          if (movies.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("home.movies".tr(),
                        style: heading.copyWith(color: textColor)),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < movies.length; i++)
                          MoviePoster(
                              poster: movies[i].poster,
                              name: movies[i].title,
                              backdrop: movies[i].backdrop,
                              date: movies[i].release_date,
                              id: movies[i].id,
                              color: textColor,
                              isMovie: true)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (movies.isNotEmpty)
            SliverToBoxAdapter(child: SizedBox(height: 10)),
          if (tv.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("home.series".tr(),
                        style: heading.copyWith(color: textColor)),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < tv.length; i++)
                          MoviePoster(
                              poster: tv[i].poster,
                              name: tv[i].title,
                              backdrop: tv[i].backdrop,
                              date: tv[i].release_date,
                              id: tv[i].id,
                              color: textColor,
                              isMovie: false)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (tv.isNotEmpty) SliverToBoxAdapter(child: SizedBox(height: 30))
        ],
      ),
    );
  }
}
