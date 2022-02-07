import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_info.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_event.dart';

import '../../../themes.dart';

class CastPoster extends StatelessWidget {
  final String poster;
  final String name;
  final Color color;
  final String id;

  const CastPoster({
    Key? key,
    required this.id,
    required this.poster,
    required this.name,
    required this.color,
  }) : super(key: key);

  moveToInfo(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              create: (context) =>
                  CastMoviesBloc()..add(LoadCastInfo(id: this.id)),
              child: CastPersonalInfoScreen(
                image: this.poster,
                title: this.name,
              ),
            )));
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
                      imageUrl: poster,
                      fit: BoxFit.cover,
                      height: 200,
                      width: 130,
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
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    // Text(
                    //   date,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: normalText.copyWith(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w900,
                    //     color: color.withOpacity(.8),
                    //   ),
                    // ),
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
