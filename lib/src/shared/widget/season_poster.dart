import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/bloc/season/season_info_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/widget/season_info.dart';
import 'package:moviebox/src/core/bloc/tv_info/widget/tv_show_info.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info.dart';
import 'package:moviebox/src/shared/util/animation.dart';

import '../../../themes.dart';

class SeasonPoster extends StatelessWidget {
 final TvInfoModel info;
 final Seasons season;
 final Color color;
  const SeasonPoster({
    Key? key,
    required this.season,
  required this.info,
    required this.color
  }) : super(key: key);
  moveToInfo(BuildContext context) {
   
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
             Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => SeasonInfoBloc()
                      ..add(LoadSeasonInfo(id: info.id.toString(), snum: season.snum)),
                    child: SeasonInfo(
                      image: info.poster,
                      title: info.title + " (${season.name})",
                    ),
                  )));
        },
        child: Container(
          constraints: BoxConstraints(minHeight: 280),
          child: Column(
            children: [
              Container(
                  height: 200,
                  width: 130,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  // color: Colors.grey.shade900,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: season.image,
                      fit: BoxFit.cover,
                    ),
                  )),
              SizedBox(height: 5),
              Container(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      season.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    RichText(
                          text: TextSpan(
                            style: normalText.copyWith(
                                color: color, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: season.date.split("-")[0] + " | ",
                              ),
                              TextSpan(
                                text: season.episodes + " Episodes",
                              ),
                            ],
                          ),
                        ),
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
