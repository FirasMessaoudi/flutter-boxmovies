import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/ui/movies_details/movies_details.controller.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_details.controller.dart';

import '../../themes.dart';

class MoviePoster extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final Color color;

  final bool isMovie;

  const MoviePoster({
    Key? key,
    required this.poster,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.isMovie,
  }) : super(key: key);

  moveToInfo(BuildContext context) {
    if (isMovie) {
     // go to movie
      Get.toNamed(AppRoutes.movieDetails,arguments: backdrop);
      MoviesDetailsController.instance.getDetails(id);

    } else {
     // go to tv
      Get.toNamed(AppRoutes.tvShowDetails,arguments: backdrop);
      TvShowsDetailsController.instance.getDetails(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(minHeight: 250),
        child: Column(
          children: [
            Container(
                height: 200,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),

                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        moveToInfo(context);
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/img/no-image.jpg'),
                            image: NetworkImage(poster),
                            fit: BoxFit.cover,
                          )
                          ),
                    ),


                  ],

                )),
            SizedBox(height: 5),
            Container(
              width: 130,
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: normalText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
      // ),
    );
  }
}
