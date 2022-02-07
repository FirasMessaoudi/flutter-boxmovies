import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/season/season_info_bloc.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/season_info.dart';
import 'package:moviebox/src/screens/cast/cast_list.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/error_page.dart';
import 'package:moviebox/src/shared/widget/favorite_button/cubit/fav_cubit.dart';
import 'package:moviebox/src/shared/widget/favorite_button/fav_button.dart';
import 'package:moviebox/src/shared/widget/loading.dart';
import 'package:moviebox/src/shared/widget/sliver_app_bar.dart';
import 'package:moviebox/src/shared/widget/trailers_widget.dart';
import 'package:readmore/readmore.dart';

import '../../../../../themes.dart';
import 'episode_info.dart';

class SeasonInfo extends StatelessWidget {
  final String image;
  final String title;

  const SeasonInfo({
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
          body: BlocBuilder<SeasonInfoBloc, SeasonInfoState>(
            builder: (context, state) {
              if (state is SeasonInfoLoading) {
                return Loading(image: image);
              } else if (state is SeasonInfoLoaded) {
                return SeasonInfoWidget(
                  info: state.seasonInfo,
                  castList: state.cast,
                  textColor: state.textColor,
                  color: state.color,
                  backdrop: image,
                  title: title,
                  trailers: state.trailers,
                  backdrops: state.backdrops,
                );
              } else if (state is SeasonInfoLoadError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class SeasonInfoWidget extends StatelessWidget {
  final SeasonModel info;
  final List<CastInfo> castList;
  final Color color;
  final String backdrop;
  final String title;

  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final Color textColor;

  const SeasonInfoWidget({
    Key? key,
    required this.info,
    required this.castList,
    required this.color,
    required this.backdrop,
    required this.title,
    required this.backdrops,
    required this.trailers,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBarCast(
              color: color,
              textColor: textColor,
              title: '',
              image: info.posterPath,
              isSeason: true),
          SliverToBoxAdapter(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: heading.copyWith(color: textColor, fontSize: 24),
                  ),
                  SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: normalText.copyWith(
                          color: textColor, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: info.customDate + " | ",
                        ),
                        TextSpan(
                          text: info.episodes.length.toString() + " Episodes",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                ],
              ),
            )),
          ),
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
                    info.overview == "N/A"
                        ? "${title}" +
                            "movie_info.premiered".tr() +
                            info.customDate
                        : info.overview,
                    trimLines: 8,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'movie_info.show_more'.tr(),
                    trimExpandedText: 'movie_info.show_less'.tr(),
                    style: normalText.copyWith(
                        fontWeight: FontWeight.w500, color: textColor),
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          if (trailers.isNotEmpty)
            TrailersWidget(
                textColor: textColor,
                trailers: trailers,
                backdrops: backdrops,
                backdrop: backdrop),
          if (castList.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child:
                        Text("Cast", style: heading.copyWith(color: textColor)),
                  ),
                  CastList(castList: castList, textColor: textColor),
                ],
              ),
            ),
          if (info.episodes.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("Episodes",
                        style: heading.copyWith(color: textColor)),
                  ),
                ],
              ),
            ),
          for (var i = 0; i < info.episodes.length; i++)
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                          builder: (context) => EpisodeInfo(
                            color: color,
                            model: info.episodes[i],
                            textColor: textColor,
                          ),
                          onClosing: () {},
                        );
                      });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: info.episodes[i].stillPath,
                            ),
                          ),
                          Positioned(
                              child: Container(
                                  color: color,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(info.episodes[i].number,
                                        style:
                                            heading.copyWith(color: textColor)),
                                  )))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: info.episodes[i].name,
                                    style: heading.copyWith(
                                        color: textColor, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              info.episodes[i].customDate,
                              style: heading.copyWith(
                                  color: textColor.withOpacity(.8),
                                  fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                IconTheme(
                                    data: IconThemeData(
                                      color: textColor == Colors.white
                                          ? Colors.amber
                                          : redColor,
                                      size: 20,
                                    ),
                                    child:
                                        Icon(Icons.star, color: Colors.amber)),
                                Text(
                                  "  " +
                                      info.episodes[i].voteAverage
                                          .toStringAsFixed(1) +
                                      "/10",
                                  style: normalText.copyWith(
                                    color: textColor == Colors.white
                                        ? Colors.amber
                                        : Colors.blue,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                BlocProvider(
                                  create: (context) => FavMovieCubit()
                                    ..init(info.episodes[i].id),
                                  child: FavIcon(
                                    type: FavType.episode,
                                    title:
                                        title + ' : ' + info.episodes[i].name,
                                    movieid: info.episodes[i].id,
                                    poster: info.episodes[i].stillPath,
                                    date: info.episodes[i].date,
                                    rate: info.episodes[i].voteAverage,
                                    isEpisode: true,
                                    color: textColor,
                                    age: '',
                                    backdrop: '',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
