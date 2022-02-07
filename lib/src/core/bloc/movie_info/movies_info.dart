import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_state.dart';
import 'package:moviebox/src/core/model/cast_info.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/src/shared/widget/expandable.dart';
import 'package:moviebox/src/shared/widget/loading.dart';
import 'package:moviebox/src/shared/widget/movie_poster.dart';
import 'package:moviebox/src/shared/widget/sliver_app_bar.dart';
import 'package:moviebox/src/shared/widget/star_icon.dart';
import 'package:moviebox/src/shared/widget/trailers_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../themes.dart';
import '../../../screens/cast/cast_list.dart';

class MoivesInfo extends StatelessWidget {
  final String image;
  final String title;

  const MoivesInfo({
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
          body: BlocBuilder<MoviesInfoBloc, MoviesInfoState>(
            builder: (context, state) {
              if (state is MoviesInfoLoading) {
                return Loading(image: image);
              } else if (state is MoviesInfoLoaded) {
                List<ImageBackdrop> images = [];

                images.add(ImageBackdrop(image: state.tmdbData.backdrops));
                images.addAll(state.images);
                print(state.color);
                print(state.textColor);
                return MovieInfoScrollableWidget(
                    info: state.tmdbData,
                    backdrops: state.backdrops,
                    similar: state.similar,
                    castList: state.cast,
                    images: images,
                    color: state.color,
                    imdbInfo: state.imdbData,
                    trailers: state.trailers,
                    textColor: state.textColor,
                    sinfo: state.sinfo);
              } else if (state is MoviesInfoError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class MovieInfoScrollableWidget extends StatelessWidget {
  final MovieInfoModel info;
  final MovieInfoImdb imdbInfo;
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> images;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final Color textColor;
  final List<MovieModel> similar;
  final Color color;
  final SocialMediaInfo sinfo;

  const MovieInfoScrollableWidget(
      {Key? key,
      required this.info,
      required this.imdbInfo,
      required this.backdrops,
      required this.trailers,
      required this.castList,
      required this.textColor,
      required this.similar,
      required this.color,
      required this.images,
      required this.sinfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBarCast(
              image: info.backdrops,
              title: info.title,
              color: color,
              textColor: textColor,
              id: info.tmdbId,
              type: FavType.movie,
              poster: info.poster,
              releaseDate: info.dateByMonth,
              homePage: info.homepage,
              trailer: trailers[0].key,
              // homepage: info.homepage,
              // images: images,
              rate: info.rateing,
              isMovie: true,
              genres: getOnlyIds(info.genres)),
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
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebookSquare, size: 40),
                      onPressed: () {
                        launch(sinfo.facebook);
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.twitterSquare, size: 40),
                      onPressed: () {
                        launch(sinfo.twitter);
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagramSquare, size: 40),
                      onPressed: () {
                        launch(sinfo.instagram);
                      },
                    ),
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
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: normalText.copyWith(color: textColor),
                        children: [
                          ...info.genres
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
                        Icon(Icons.calendar_today, color: textColor),
                        SizedBox(width: 5),
                        Text(
                          convertDate(
                              info.releaseDate, context.locale.languageCode),
                          style: normalText.copyWith(color: textColor),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            color: textColor == Colors.white
                                ? Colors.amber
                                : Colors.blue,
                            size: 20,
                          ),
                          child: StarDisplay(
                            value: ((info.rateing * 5) / 10).round(),
                          ),
                        ),
                        Text(
                          "  " + info.rateing.toString() + "/10",
                          style: normalText.copyWith(
                            color: textColor == Colors.white
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
          if (info.overview != '')
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("movie_info.overview".tr(),
                        style: heading.copyWith(color: textColor)),
                    SizedBox(height: 10),
                    ReadMoreText(
                      info.overview,
                      trimLines: 6,
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
          if (trailers.isNotEmpty)
            TrailersWidget(
              textColor: textColor,
              trailers: trailers,
              backdrops: backdrops,
              backdrop: info.backdrops,
            ),
          if (castList.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("movie_info.cast".tr(),
                        style: heading.copyWith(color: textColor)),
                  ),
                  CastList(castList: castList, textColor: textColor),
                ],
              ),
            ),
          SliverToBoxAdapter(
            child: ExpandableGroup(
              isExpanded: true,
              expandedIcon: Icon(
                Icons.arrow_drop_up,
                color: textColor != Colors.white ? Colors.black : Colors.white,
              ),
              collapsedIcon: Icon(
                Icons.arrow_drop_down,
                color: textColor != Colors.white ? Colors.black : Colors.white,
              ),
              header: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "movie_info.about_movie".tr(),
                  style: heading.copyWith(color: textColor),
                ),
              ),
              items: [
                if (info.tagline != '')
                  ListTile(
                      title: Text(
                        "movie_info.tagline_movie".tr(),
                        style: heading.copyWith(color: textColor, fontSize: 16),
                      ),
                      subtitle: Text(
                        info.tagline,
                        style: normalText.copyWith(color: textColor),
                      )),
                ListTile(
                    title: Text(
                      "movie_info.runtime".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.runtime,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "movie_info.writers".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.writer,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "movie_info.director".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.director,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "movie_info.released_movie".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      convertDate(
                          info.releaseDate, context.locale.languageCode),
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "movie_info.rating".tr(),
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.rated,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "BoxOffice",
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.boxOffice,
                      style: normalText.copyWith(color: textColor),
                    )),
              ],
            ),
          ),
          if (similar.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("movie_info.similar_movie".tr(),
                        style: heading.copyWith(color: textColor)),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < similar.length; i++)
                          MoviePoster(
                              poster: similar[i].poster,
                              name: similar[i].title,
                              backdrop: similar[i].backdrop,
                              date: similar[i].release_date,
                              id: similar[i].id,
                              color: textColor,
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
    );
  }

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }
}
