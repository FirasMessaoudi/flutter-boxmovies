import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:readmore/readmore.dart';

import '../../../themes.dart';


class InfoModal extends StatelessWidget {
  final MovieModel movie;

  const InfoModal({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: const EdgeInsets.all(8.0),
        // child: InkWell(
        //     onTap: () {
        //       // moveToInfo(context);
        //     },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.grey.shade900,
                  child: CachedNetworkImage(
                    imageUrl: movie.poster,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: heading.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(movie.release_date,
                                style: normalText.copyWith(
                                  color: Colors.grey,
                                )),
                            ReadMoreText(
                              movie.overview,
                              trimLines: 6,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: smalltext.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                              moreStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.info_outline),
                                    Text(' Details & more',style: normalText.copyWith(fontSize: 13,fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                IconButton(
                                    onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                            MoviesInfoBloc()..add(LoadMoviesInfo(id: movie.id)),
                                            child: MoivesInfo(
                                              image: movie.backdrop,
                                              title: movie.title,
                                            ),
                                          )));
                                    },
                                    icon: Icon(Icons.arrow_forward_ios))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
