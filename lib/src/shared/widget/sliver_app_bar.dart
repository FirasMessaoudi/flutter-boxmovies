import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviebox/src/core/model/categorie.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/actions_bottom_sheet.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/widget/watchlist_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../themes.dart';
import 'collection_button/add_collection_button.dart';
import 'collection_button/cubit/add_collection_cubit.dart';
import 'favorite_button/cubit/fav_cubit.dart';
import 'favorite_button/fav_button.dart';
import 'image_view.dart';
import 'package:share/share.dart';

class SliverAppBarCast extends StatelessWidget {
  const SliverAppBarCast(
      {Key? key,
      required this.textColor,
      required this.title,
      required this.image,
      required this.color,
      this.id = '',
      this.type = FavType.movie,
      this.releaseDate = '',
      this.poster = '',
      this.rate = 10,
      this.isMovie = true,
      this.age = '',
      this.isActor = false,
      this.homePage,
        this.trailer,
        this.isSeason = false,
        this.genres

      })
      : super(key: key);
  final Color textColor;
  final String title;
  final String image;
  final Color color;
  final String id;
  final FavType type;
  final String poster;
  final String releaseDate;
  final double rate;
  final bool isMovie;
  final String age;
  final bool isActor;
  final String? homePage;
  final String? trailer;
  final bool? isSeason;
  final List<int>? genres;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return SliverAppBar(
        pinned: true,
        stretch: true,
        brightness:
            textColor == Colors.black ? Brightness.light : Brightness.dark,
        elevation: 0,
        backgroundColor: color,
        expandedHeight: 400,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isActor
                ? BlocProvider(
                    create: (context) => FavMovieCubit()..init(id),
                    child: FavIcon(
                        type: type,
                        title: title,
                        movieid: id,
                        poster: age != '' ? image : poster,
                        date: releaseDate,
                        rate: rate,
                        age: age,
                        isEpisode: true,
                        color: textColor,
                        backdrop: image),
                  )
                : IconButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null && isSeason==false)
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            builder: (context) {
                              return BottomSheet(
                                  backgroundColor: color,
                                  onClosing: () {},
                                  builder: (context) =>
                                      ActionsBottomSheet(id, title, poster, releaseDate,
                                          isMovie, rate, image, textColor, type, homePage, age, genres)


                                     /* Container(
                                          child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          BlocProvider(
                                            create: (context) =>
                                                WatchlistCubit()..init(id),
                                            child: WatchListIcon(
                                                fromBottomSheet: true,
                                                title: title,
                                                movieid: id,
                                                poster: poster,
                                                date: releaseDate,
                                                rate: rate,
                                                isMovie: isMovie,
                                                color: textColor,
                                                backdrop: image),
                                          ),
                                          BlocProvider(
                                            create: (context) =>
                                                CollectionCubit()..init(id),
                                            child: AddCollectionIcon(
                                              date: releaseDate,
                                              image: poster,
                                              isMovie: isMovie,
                                              rate: rate,
                                              title: title,
                                              movieid: id,
                                              likeColor: textColor,
                                              unLikeColor: textColor,
                                              backdrop: image,
                                            ),
                                          ),
                                          BlocProvider(
                                            create: (context) =>
                                                FavMovieCubit()..init(id),
                                            child: FavIcon(
                                                type: type,
                                                title: title,
                                                movieid: id,
                                                poster:
                                                    age != '' ? image : poster,
                                                date: releaseDate,
                                                rate: rate,
                                                age: age,
                                                color: textColor,
                                                backdrop: image),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              if(homePage!=null)
                                              Share.share(
                                                      homePage!);
                                            },
                                            leading: Icon(Icons.share,color: textColor),
                                            title: Text(
                                              'actions.share'.tr(),
                                              style: normalText.copyWith(
                                                color: textColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ))*/
                              );
                            });
                    },
                    icon: DecoratedIcon(
                      Icons.more_horiz,
                      color: textColor,
                      size: 35.0,
                    ),
                  ),
          )
        ],
        leading: IconButton(
          icon: DecoratedIcon(
            Icons.arrow_back_sharp,
            color: textColor,
            size: 30.0,
            shadows: [
              BoxShadow(
                blurRadius: 92.0,
                color: color,
              ),
              BoxShadow(
                blurRadius: 12.0,
                color: color,
              ),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: textColor),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
          centerTitle: true,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          background: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPhotos(
                    imageList: [
                      ImageBackdrop(image: image),
                    ],
                    imageIndex: 0,
                    color: color,
                  ),
                ),
              );
            },
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.center,
                  begin: Alignment.bottomCenter,
                  colors: [
                    color,
                    color.withOpacity(.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: color,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      image,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
