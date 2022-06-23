import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/genres.model.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/widget/appbar.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/ui/genre/results/movies_by_genre.controller.dart';
import 'package:moviebox/ui/genre/results/tv_shows_by_genre.controller.dart';
import 'package:moviebox/ui/search/search_delegate.dart';


import '../../themes.dart';

class GenreListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = GenresList.fromJson(genreslist).list;

    return Scaffold(
      appBar:  DefaultAppBar(title: 'home.genres'.tr),
      body: SafeArea(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    "discover.popular_genres".tr,
                    style: heading.copyWith(
                      color: Theme.of(context).brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                    ),
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
                  "discover.browse_all".tr,
                  style: heading.copyWith(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
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
            ],
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
    print(genre.nameAr);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          //init tv & movies genre controller
          MoviesByGenreController.instance.initSearch(genre.id);
          TvShowsByGenreController.instance.initSearch(genre.idTv);
          Get.toNamed(AppRoutes.genresResult,arguments:genre.name);

        },
        child: Stack(children: <Widget>[
          Container(
              height: 500.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.asset(
                    'assets/img/' + genre.image,
                    fit: BoxFit.cover,
                  ))),

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

          Center(
              child: Text(
            Get.locale!.languageCode == 'ar' ? genre.nameAr : genre.name,
            style: TextStyle(color: Colors.white),
          )),
        ]),
      ),
    );
  }
}
