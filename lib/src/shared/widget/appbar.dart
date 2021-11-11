
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/shared/widget/image_view.dart';


class SliverAppBarWithShadow extends StatelessWidget {
  SliverAppBarWithShadow({
    Key? key,
    required this.textColor,
    required this.images,
    required this.homepage,
    required this.title,
    required this.image,
    required this.color,
    required this.poster,
    required this.id,
    required this.releaseDate,
    required this.isMovie,
    required this.rate,
  }) : super(key: key);
  final Color textColor;
  final String homepage;
  final String title;
  final String image;
  final double rate;
  final Color color;
  final List<ImageBackdrop> images;
  final String poster;
  final String id;
  final String releaseDate;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        pinned: true,
        forceElevated: true,
        stretch: true,
        brightness:
            textColor == Colors.black ? Brightness.light : Brightness.dark,
        elevation: 0,
        backgroundColor: color,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: DecoratedIcon(
                Icons.favorite_border,
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
        expandedHeight: 300,
        iconTheme: IconThemeData(color: textColor),
        flexibleSpace: FlexibleSpaceBar(
          // stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
          centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPhotos(
                    imageList: images,
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
                  color: color,
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
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.center,
                        begin: Alignment.bottomCenter,
                        colors: [
                          color.withOpacity(.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }
}
