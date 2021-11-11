import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/repo/fav_repo.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/actions_bottom_sheet.dart';
import 'package:moviebox/src/shared/widget/confetti_widget.dart';
import 'package:moviebox/src/shared/widget/episode_fav.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../../themes.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoriteMovieContainer extends StatefulWidget {
  final FavoriteWatchListModel movie;
  final bool isFavorite;
  final bool isEpisode;
  final bool isActor;
  final bool isMovie;
  const FavoriteMovieContainer(
      {Key? key,
      required this.movie,
      required this.isFavorite,
      this.isActor = false,
      this.isEpisode = false,
      this.isMovie = false})
      : super(key: key);

  @override
  _FavoriteMovieContainerState createState() => _FavoriteMovieContainerState();
}

class _FavoriteMovieContainerState extends State<FavoriteMovieContainer> {
  bool isDeleted = false;
  bool isWatched = false;
  final repo = FavRepo();
  final watchlistRepo = new WatchListRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isWatched = widget.movie.watched;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        // child: InkWell(
        //     onTap: () {
        //       // moveToInfo(context);
        //     },
        child: !widget.isEpisode && !widget.isActor && !isDeleted
            ? Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            moveToInfo(context, widget.isMovie, widget.movie.id,
                                widget.movie.backdrop, widget.movie.title);
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                builder: (context) {
                                  return BottomSheet(
                                    //backgroundColor: color,
                                    onClosing: () {},
                                    builder: (context) => ActionsBottomSheet(
                                        widget.movie.id,
                                        widget.movie.title,
                                        widget.movie.poster,
                                        widget.movie.date,
                                        widget.movie.isMovie,
                                        widget.movie.rate,
                                        widget.movie.backdrop,
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        widget.isMovie
                                            ? FavType.movie
                                            : FavType.tv,
                                        '',
                                        '',
                                      null
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            color: Colors.grey.shade900,
                            child: CachedNetworkImage(
                              imageUrl: widget.movie.poster,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.movie.title,
                                    style: heading.copyWith(
                                      fontSize: 16,
                                      //  color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(widget.movie.date,
                                      style: normalText.copyWith(
                                          // color: Colors.white,
                                          )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      IconTheme(
                                        data: IconThemeData(
                                          // color: Colors.yellowAccent,
                                          size: 20,
                                        ),
                                        child: Icon(Icons.star,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.yellow
                                                    : Colors.black45),
                                      ),
                                      // Icon(Icons.star, color: Colors.yellow),

                                      Text(
                                        "" +
                                            widget.movie.rate.toString() +
                                            "/10",
                                        style: normalText.copyWith(
                                          //color: Colors.white,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 9),
                                 Text(widget.movie.genres, style: normalText,),
                                  SizedBox(height: 9),
                                  if(!widget.isFavorite)
                                  OutlinedButton(
                                    onPressed: () async {
                                      if (isWatched == true) {
                                        await watchlistRepo.updateWatchlist(
                                            widget.movie, false);
                                        setState(() {
                                          isWatched = false;
                                        });
                                      } else {
                                        await watchlistRepo.updateWatchlist(
                                            widget.movie, true);
                                        setState(() {
                                          isWatched = true;

                                        });
                                      }
                                      print(isWatched);
                                    },
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.0,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black) // side: Bord
                                        ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isWatched == true
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 20,
                                          color: redColor,
                                        ),
                                        Text(
                                          isWatched == true
                                              ? 'my_list.not_watched'.tr()+ ' ?'
                                              : 'my_list.watched'.tr()+ ' ?',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 9),
                                  if (isWatched == true && !widget.isFavorite)
                                    Wrap(
                                      children: [
                                        Text(
                                          'my_list.how_was_it'.tr(),
                                          style: normalText.copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                       SmoothStarRating(
                                            allowHalfRating: true,
                                            onRated: (v) async{
                                              await watchlistRepo.rateMovieOrTvShow(widget.movie, v);
                                            },
                                            starCount: 5,
                                            rating: widget.movie.note,
                                            size: 20.0,
                                            isReadOnly: false,
                                            filledIconData: Icons.star,
                                            halfFilledIconData: Icons.star_half,
                                            color: Colors.yellow,
                                            borderColor: Colors.grey,
                                            spacing: 0.0),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : !isDeleted && (widget.isActor || widget.isEpisode)
                ? new EpisodeFav(
                    poster: widget.movie.poster,
                    backdrop: widget.movie.poster,
                    name: widget.movie.title,
                    date: widget.movie.date,
                    id: widget.movie.id,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    isMovie: false,
                    isEpisode: widget.isEpisode,
                    isActor: widget.isActor,
                    age: widget.movie.age,
                    rate: widget.movie.rate)
                : new Container());
  }

  deleteFavorite() async {
    if (widget.isFavorite)
      await repo.deleteFromFav(widget.movie.id);
    else
      await watchlistRepo.deleteFromWatchList(widget.movie.id);
    setState(() {
      isDeleted = true;
    });
  }
}

class ConfettiAnimation extends StatefulWidget{
  static final GlobalKey<ConfettiAnimationState> globalKey = GlobalKey();

  @override
  State<ConfettiAnimation> createState() => ConfettiAnimationState();
}

class ConfettiAnimationState extends State<ConfettiAnimation> {
  late  ConfettiController _controllerCenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerCenter.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return     GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_controllerCenter.state == ConfettiControllerState.playing) {
          _controllerCenter.stop();
        } else {
          _controllerCenter.play();
        }
      },
      child: Stack(
        children: [
          _buildConfetti(),
        ],
      ),
    );
  }
  Widget _buildConfetti(){
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _controllerCenter,
        blastDirectionality: BlastDirectionality
            .explosive, // don't specify a direction, blast randomly
        shouldLoop:
        true, // start again as soon as the animation is finished
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ], // manually specify the colors to be used
        createParticlePath: drawStar, // define a custom shape/path.
      ),
    );
  }
  void play(){
    _controllerCenter.play();
  }
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

}