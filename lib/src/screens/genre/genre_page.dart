import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/model/genres_model.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/screens/genre/genre_info.dart';
import 'package:moviebox/src/screens/search/search_delegate.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../themes.dart';

class GenrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = GenresList.fromJson(genreslist).list;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    if (Responsive.isMobile(context))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          child: Text(
                            "discover.search".tr(),
                            style: heading.copyWith(
                                color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black, fontSize: 28),
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (Responsive.isMobile(context))
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          style: normalText,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              hintText: "discover.search_label".tr(),
                              hintStyle: normalText,
                              // fillColor: Colors.black,
                              filled: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                          onTap: () {
                            showSearch(
                                context: context, delegate: DataSearch());
                          },
                        ),
                      ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            IconButton(
                                tooltip: 'login.back'.tr(),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.arrow_back_sharp)),
                            Text(
                              "discover.popular_genres".tr(),
                              style: heading.copyWith(
                                color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 28 / 16),
                        children: [
                          for (var i = 0; i < 4; i++)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GenreTile(
                                genre: genres[i],
                              ),
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        "discover.browse_all".tr(),
                        style: heading.copyWith(
                          color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 28 / 16),
                        children: [
                          for (var i = 4; i < genres.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GenreTile(
                                genre: genres[i],
                              ),
                            )
                        ],
                      ),
                    ),
                    // BlocProvider(
                    //   create: (context) =>
                    //       UpcomingMoviesBloc()..add(LoadUpcomingMovies()),
                    //   child: UpcomingMoviesResults(),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenreTile extends StatelessWidget {
  final Genres genre;
  GenreTile({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (conetex) => GenreInfo(
                    id: genre.id,
                    title: genre.name,
                  )));
        },
        child: Stack(children: <Widget>[
          Container(
              height: 500.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.asset(
                    'assets/img/'+genre.image,
                    fit: BoxFit.cover,
                  ))),
          // image: DecorationImage(
          //   image: NetworkImage(genre.image),
          //   fit: BoxFit.cover,
          // ),

          Container(
            height: 500.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          //new CachedNetworkImage(imageUrl: genre.image),

          Center(child: Text(genre.name, style: TextStyle(color: Colors.white),)),
        ]),
        // child: Container(
        //    decoration: BoxDecoration(
        //           color:genre.color,
        //          borderRadius: BorderRadius.all(Radius.circular(8.0))
        //         ),
        //   child: Stack(
        //     children: [
        //       Container(
        //         width: double.infinity,
        //         height: double.infinity,
        //       ),
        //       Positioned(
        //         bottom: -5,
        //         right: -20,
        //         child: RotationTransition(
        //           turns: new AlwaysStoppedAnimation(380 / 360),
        //           child: Container(
        //             padding: EdgeInsets.all(8),
        //             child: CachedNetworkImage(
        //               imageUrl: genre.image,
        //               fit: BoxFit.cover,
        //               width: 65,
        //               height: 75,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Container(
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(
        //               horizontal: 12.0, vertical: 4.0),
        //           child: Text(
        //             genre.name,
        //             style: normalText.copyWith(
        //               fontWeight: FontWeight.w700,
        //               color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
