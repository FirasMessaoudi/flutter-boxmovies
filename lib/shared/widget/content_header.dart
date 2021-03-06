import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/shared/widget/info_modal.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/shared/widget/watchlist_button/widget/watchlist_icon.dart';

class ContentHeader extends StatelessWidget {
  final MovieModel featuredContent;

  const ContentHeader({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileHeader(featuredContent: featuredContent),
      desktop: DesktopHeader(featuredContent: featuredContent),
      tablet: Text(''),
    );
  }
}

class MobileHeader extends StatelessWidget {
  final MovieModel featuredContent;

  const MobileHeader({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(featuredContent.poster!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 500.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 100.0,
          child: Column(
              // width: 250.0,
              children: [
                Text(
                  featuredContent.title??'',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                ),
                Text(
                  Get.locale!.languageCode == 'ar'
                      ? getMoviesCategorieNamesAr(featuredContent.genres??[])
                          .substring(
                              0,
                              getMoviesCategorieNamesAr(featuredContent.genres??[])
                                      .lastIndexOf(',') -
                                  1)
                      : getMoviesCategorieNames(featuredContent.genres??[])
                          .substring(
                              0,
                              getMoviesCategorieNames(featuredContent.genres??[])
                                      .lastIndexOf(',') -
                                  1),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0),
                  ),
                )
              ]),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (FirebaseAuth.instance.currentUser != null)
                VerticalIconButton(
                    icon: Icons.add, title: 'List', movie: featuredContent),
              if (FirebaseAuth.instance.currentUser == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: Get.locale!.languageCode == 'ar'
                            ? EdgeInsets.only(right: 5.0)
                            : EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                        )),
                    Text(
                      "  " + featuredContent.vote_average.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              _PlayButton(),
              VerticalIconButton(
                  icon: Icons.info_outline,
                  title: 'Info',
                  movie: featuredContent),
            ],
          ),
        ),
      ],
    );
  }
}

class DesktopHeader extends StatefulWidget {
  final dynamic featuredContent;

  const DesktopHeader({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);

  @override
  _DesktopHeaderState createState() => _DesktopHeaderState();
}

class _DesktopHeaderState extends State<DesktopHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 600.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.featuredContent.backdrop),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          height: 600.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          left: 60.0,
          right: 60.0,
          bottom: 50.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.featuredContent.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0),
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.featuredContent.overview,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2.0, 4.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  _PlayButton(),
                  const SizedBox(width: 16.0),
                  FlatButton.icon(
                    padding: const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
                    onPressed: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        builder: (context) {
                          return Wrap(
                            children: <Widget>[
                              InfoModal(movie: widget.featuredContent)
                            ],
                          );
                        }),
                    color: Colors.white,
                    icon: const Icon(Icons.info_outline,
                        color: Colors.black, size: 30.0),
                    label: const Text(
                      'More Info',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      padding: !Responsive.isDesktop(context)
          ? const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0)
          : const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
      onPressed: () => {showToast()},
      color: Colors.white,
      icon: const Icon(Icons.play_arrow, size: 30.0, color: Colors.black),
      label: Text(
        'home.play_button'.tr,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }
}

class VerticalIconButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final MovieModel movie;

  // final Function onTap;

  const VerticalIconButton(
      {Key? key, required this.icon, required this.title, required this.movie
      // required this.onTap,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Info') {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              builder: (context) {
                return Wrap(
                  children: <Widget>[InfoModal(movie: movie)],
                );
              });
        }
      },
      child: Column(
        children: [
          title == 'List'
              ? BlocProvider(
            create: (context) => WatchlistCubit()..init(movie.id??'', true),
                  child: WatchListIcon(
                      movieid: movie.id??'',
                      title: movie.title??'',
                      poster: movie.poster??'',
                      backdrop: movie.backdrop??'',
                      date: movie.release_date??'',
                      rate: movie.vote_average??0,
                      isMovie: true,
                      color: Colors.white,
                      genres: movie.genres),
                )
              : Icon(icon, color: Colors.white),
          const SizedBox(height: 2.0),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
