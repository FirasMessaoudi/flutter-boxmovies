import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/shared/widget/star_icon.dart';

import '../../themes.dart';

class HorizontalMoviePoster extends StatelessWidget {
  final String? poster;
  final String? name;
  final String? backdrop;
  final String date;
  final String id;
  final Color color;
  final bool isMovie;
  final double rate;

  const HorizontalMoviePoster({
    Key? key,
    this.poster,
    this.name,
    this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.isMovie,
    required this.rate,
  }) : super(key: key);

  moveToInfo(BuildContext context) {
    if (isMovie) {
      // go to movie

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          moveToInfo(context);
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  height: 150,
                  width: 90,
                  color: Colors.grey.shade900,
                  child: CachedNetworkImage(
                    imageUrl: poster!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: normalText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (date != "") SizedBox(height: 5),
                      if (date != "")
                        Text(
                          date,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: normalText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: color.withOpacity(.8),
                          ),
                        ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: redColor,
                              size: 20,
                            ),
                            child: StarDisplay(
                              value: ((rate * 5) / 10).round(),
                            ),
                          ),
                          Text(
                            "  " + rate.toString() + "/10",
                            style: normalText.copyWith(
                              color: redColor,
                              letterSpacing: 1.2,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
