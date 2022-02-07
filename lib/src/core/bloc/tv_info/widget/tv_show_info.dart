import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_state.dart';
import 'package:moviebox/src/core/model/cast_info.dart';
import 'package:moviebox/src/screens/cast/cast_list.dart';
import 'package:moviebox/src/screens/network/network_info.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/src/shared/widget/expandable_seasons.dart';
import 'package:moviebox/src/shared/widget/movie_poster.dart';
import 'package:moviebox/src/shared/widget/sliver_app_bar.dart';
import 'package:moviebox/src/shared/widget/trailers_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../themes.dart';
import '../../../../shared/widget/loading.dart';
import '../../../../shared/widget/star_icon.dart';
import '../../../model/movie_info_model.dart';
import '../../../model/tv_model.dart';
import '../../../model/tv_shows_info.dart';
import '../show_info_bloc.dart';
import 'about_shows.dart';
import 'overview_widget.dart';

class TvInfo extends StatelessWidget {
  final String image;
  final String title;

  const TvInfo({
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
          body: BlocBuilder<ShowInfoBloc, ShowInfoState>(
            builder: (context, state) {
              if (state is ShowInfoLoading) {
                return Loading(image: image);
              } else if (state is ShowInfoLoaded) {
                List<ImageBackdrop> images = [];
                images.add(ImageBackdrop(image: state.tmdbData.backdrops));
                images.addAll(state.images);
                print(state.color);
                return TvInfoScrollableWidget(
                    info: state.tmdbData,
                    backdrops: state.backdrops,
                    similar: state.similar,
                    castList: state.cast,
                    color: state.color,
                    trailers: state.trailers,
                    textColor: state.textColor,
                    images: images,
                    sinfo: state.sinfo);
              } else if (state is ShowInfoError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class TvInfoScrollableWidget extends StatelessWidget {
  final TvInfoModel info;
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> images;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final Color textColor;
  final List<TvModel> similar;
  final Color color;
  final SocialMediaInfo sinfo;

  TvInfoScrollableWidget(
      {Key? key,
      required this.info,
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
              id: info.id.toString(),
              type: FavType.tv,
              releaseDate: info.date,
              poster: info.poster,
              rate: info.rateing,
              isMovie: false,
              homePage: info.homepage,
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
                          convertDate(info.date, context.locale.languageCode),
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
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "movie_info.watch_on".tr(),
                          style:
                              heading.copyWith(color: textColor, fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i = 0; i < info.networks.length; i++)
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) => NetworkInfo(
                                                  id: info.networks[i].id,
                                                  title: info.networks[i].name,
                                                )));
                                  },
                                  child: info.networks[i].id != '2739'
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              'https://www.themoviedb.org/t/p/w92/' +
                                                  info.networks[i].logo_path,
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
          if (info.overview != '')
            OverviewWidget(textColor: textColor, info: info),
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
          AboutShowWidget(textColor: textColor, info: info),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("my_list.episodes".tr(),
                  style: heading.copyWith(color: textColor)),
            ),
          ),
          // ...info.seasons
          //     .map((season) => SeasonsWidget(
          //           info: info,
          //           textColor: textColor,
          //           season: season,
          //         ))
          //     .toList(),
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
                      for (var i = 0; i < this.info.seasons.length; i++)
                        if (this.info.seasons[i].name != 'Specials')
                          ExpandableSeason(
                            tvName: info.title,
                            backdrop: info.backdrops,
                            epRuntime: info.episoderuntime,
                            tvDate: info.date,
                            tvRate: info.rateing,
                            tvImage: info.poster,
                            tvGenre:
                                getCatgoryNameFromCatgeoryObject(info.genres),
                            textColor: textColor,
                            headerBackgroundColor: color,
                            items: [],
                            tvId: this.info.id,
                            season: this.info.seasons[i],
                            isExpanded: false,
                            expandedIcon: Icon(
                              Icons.arrow_drop_up,
                              color: textColor != Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            collapsedIcon: Icon(
                              Icons.arrow_drop_down,
                              color: textColor != Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            header: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                this.info.seasons[i].name,
                                style: heading.copyWith(color: textColor),
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
                  child: Text("movie_info.similar_tv".tr(),
                      style: heading.copyWith(color: textColor)),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < similar.length; i++)
                        MoviePoster(
                          isMovie: false,
                          id: similar[i].id,
                          name: similar[i].title,
                          backdrop: similar[i].backdrop,
                          poster: similar[i].poster,
                          color: textColor,
                          date: similar[i].release_date,
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
    );
  }
}
