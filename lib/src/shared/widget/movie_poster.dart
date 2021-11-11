import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/widget/tv_show_info.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/shared/util/animation.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_event.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/widget/watchlist_icon.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

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
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    MoviesInfoBloc()..add(LoadMoviesInfo(id: this.id)),
                child: MoivesInfo(
                  image: this.backdrop,
                  title: this.name,
                ),
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    ShowInfoBloc()..add(LoadTvInfo(id: this.id)),
                child: TvInfo(
                  image: this.backdrop,
                  title: this.name,
                ),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
     // child: InkWell(
        // onTap: () {
        //   moveToInfo(context);
        // },
        child: Container(
          constraints: BoxConstraints(minHeight: 280),
          child: Column(
            children: [
              Container(
                  height: 200,
                  width: 130,
                  decoration: BoxDecoration(
                      // color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  // color: Colors.grey.shade900,

                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap:() 
                        
                        {moveToInfo(context);
                        
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child:
                          FadeInImage(
                            placeholder: AssetImage('assets/img/no-image.jpg'),
                            image: NetworkImage(poster),
                            fit: BoxFit.cover,
                          )
                          //  CachedNetworkImage(
                          //   imageUrl: poster,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),

                      // Image.network(
                      //   poster,
                      //   fit: BoxFit.cover,
                      // ),




                    ],
                    // borderRadius: BorderRadius.circular(10.0),
                    // child: CachedNetworkImage(
                    //   imageUrl: poster,
                    //   fit: BoxFit.cover,
                    // ),
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
     // ),
    );
  }
}
