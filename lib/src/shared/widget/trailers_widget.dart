import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/shared/widget/video_player.dart';
import 'package:share/share.dart';

import '../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';

class TrailersWidget extends StatelessWidget {
  const TrailersWidget({
    Key? key,
    required this.textColor,
    required this.trailers,
    required this.backdrops,
    required this.backdrop,
  }) : super(key: key);

  final Color textColor;
  final List<TrailerModel> trailers;
  final List<ImageBackdrop> backdrops;
  final String backdrop;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text("movie_info.trailers".tr(), style: heading.copyWith(color: textColor)),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < trailers.length; i++)
                  if (trailers[i].site == 'YouTube')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoPlayer(
                                id: trailers[i].key,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(minHeight: 150),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    color: Colors.black,
                                    child: CachedNetworkImage(
                                      imageUrl: backdrops.isNotEmpty
                                          ? backdrops[Random()
                                                  .nextInt(backdrops.length)]
                                              .image
                                          : backdrop,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 180,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.play_arrow,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 170,
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      trailers[i].name,
                                      maxLines: 2,
                                      style: normalText.copyWith(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                     GestureDetector(
                                       onTap: (){
                                         Share.share('Check the trailer '+ 'https://www.youtube.com/embed/${trailers[i].key}');
                                       },
                                         child: Icon(Icons.share, size: 15.0, color: textColor,)

                                     )

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
