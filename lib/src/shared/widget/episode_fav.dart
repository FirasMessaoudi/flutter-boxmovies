import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_info.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_event.dart';
import 'package:moviebox/src/core/repo/fav_repo.dart';

import '../../../themes.dart';

class EpisodeFav extends StatefulWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final Color color;
  final double rate;
  final bool isMovie;
  final bool isEpisode;
  final String age;
  final bool isActor;
  const EpisodeFav(
      {Key? key,
        required this.poster,
        required this.rate,
        required this.name,
        required this.backdrop,
        required this.date,
        required this.id,
        required this.color,
        required this.isMovie,
        this.age ='',
        this.isActor = false,
        this.isEpisode = false})
      : super(key: key);

  @override
  State<EpisodeFav> createState() => _EpisodeFavState();
}

class _EpisodeFavState extends State<EpisodeFav> {
  bool isDeleted = false;
  moveToInfo(BuildContext context) {
    if (widget.isActor) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CastMoviesBloc()
              ..add(LoadCastInfo(id: widget.id)),
            child: CastPersonalInfoScreen(
              image: widget.backdrop,
              title: widget.name,
            ),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isDeleted?Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        child: Container(
          constraints: BoxConstraints(minHeight: 240),
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      moveToInfo(context);
                    },
                    child:  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: CachedNetworkImage(
                        imageUrl: widget.backdrop,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Align(

                    alignment: Alignment.topRight,
                    child:
                    GestureDetector(
                      onTap: () async{
                        final repo = new FavRepo();
                           await repo.deleteFromFav(widget.id);
                           setState(() {
                             isDeleted = true;
                           });

                      },
                      child:Icon(Icons.favorite,color:redColor,size: 30,),

                    )
                  )
                ],

                  //height: 180,

              ),

              // SizedBox(height: 5),
              Container(
                // width: 330,
                // height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      !widget.isActor?widget.name:widget.age!=''?widget.name+': '+widget.age +' old':widget.name,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      widget.date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: widget.color.withOpacity(.8),
                      ),
                    ),
                    if (widget.isEpisode)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                             Icons.star
                            ),
                            Text(
                              "  " +
                                  widget.rate.toStringAsFixed(1) +
                                  "/10",
                              style: normalText.copyWith(
                                color: widget.color,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ):Container();
  }
}
