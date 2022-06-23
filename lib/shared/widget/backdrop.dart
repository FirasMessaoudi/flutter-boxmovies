import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/ui/movies_details/movies_details.controller.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_details.controller.dart';

import '../../themes.dart';

class BackdropPoster extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final double rate;
  final bool isMovie;
  final Color? color;

  const BackdropPoster({
    Key? key,
    required this.poster,
    required this.rate,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.isMovie,
    this.color,
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
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: () {
          moveToInfo(context);
        },
        child: Container(
         // constraints: BoxConstraints(minHeight: 240),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  width: 330,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: backdrop,
                      fit: BoxFit.cover,
                    ),
                  )),
              // SizedBox(height: 5),
              Container(
                // width: 330,
                // height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      convertDate(date, Get.locale!.languageCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
