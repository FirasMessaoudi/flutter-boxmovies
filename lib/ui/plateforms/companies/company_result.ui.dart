import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/shared/widget/appbar.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/shared/widget/backdrop.dart';
import 'package:moviebox/ui/plateforms/companies/company_result.controller.dart';

import '../../../themes.dart';
class CompanyResultView extends GetView<CompanyResultController> {
  @override
  Widget build(BuildContext context) {
    return
      MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            appBar: DefaultAppBar(title: controller.title),
          body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          controller: controller.scrollController,
          slivers: [
            SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<MovieModel>>(
              stream: controller.repo.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: [
                        Responsive.isMobile(context) ||
                            Responsive.isTablet(context)
                            ? ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            ...controller.repo.tvshows
                                .map((movie) => new BackdropPoster(
                                poster: movie.poster!,
                                backdrop: movie.backdrop!,
                                name: movie.title!,
                                date: movie.release_date!,
                                id: movie.id!,
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                isMovie: true,
                                rate: 9))
                                .toList()
                          ],
                        )
                            : GridView(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 28 / 16),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...controller.repo.tvshows
                                .map((movie) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new BackdropPoster(
                                    poster: movie.poster!,
                                    backdrop: movie.backdrop!,
                                    name: movie.title!,
                                    date: movie.release_date!,
                                    id: movie.id!,
                                    color: Theme.of(context)
                                        .brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    isMovie: true,
                                    rate: 9)))
                                .toList()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!controller.repo.isfinish)
                          Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                color: redColor,
                              ))
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Look like you reach the end!",
                                style: normalText.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
            ),
          ],
        ),
        ),
      );

  }
}
