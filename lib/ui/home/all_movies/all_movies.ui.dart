import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/movie.model.dart';
import 'package:moviebox/shared/widget/appbar.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/shared/util/constant.dart';
import 'package:moviebox/shared/widget/backdrop.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';

import '../../../themes.dart';

class AllMoviesView extends  GetView<AllMoviesController> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
          initialIndex: 0,
          length: 1,
          child: Scaffold(
            appBar: DefaultAppBar(title: 'home.movies'.tr),
            body: Scaffold(
            floatingActionButton: FloatingActionButton(
            backgroundColor: Get.isDarkMode
            ? Colors.white
                : Colors.black,
                child: const Icon(Icons.filter, color: Colors.red),
                onPressed: () => {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 6),
                                Text(
                                  'filter.sort_by'.tr,
                                  style: heading.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomRadioButton(
                                  unSelectedColor: Colors.white,

                                  buttonLables: controller.sortListLabels,
                                  buttonValues: controller.sortListValues,

                                  radioButtonValue: (value) {
                                    controller.sortBy = value.toString();
                                  },
                                  // defaultSelected: ["Monday"],
                                  horizontal: false,
                                  width: 120,
                                  // hight: 50,
                                  selectedColor: redColor,

                                  padding: 5,
                                  spacing: 0.0,
                                  enableShape: true,
                                ),
                                SizedBox(height: 8),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 6),
                                Text(
                                  'filter.countries'.tr,
                                  style: heading.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomRadioButton(
                                  unSelectedColor: Colors.white,

                                  buttonLables: Get.locale!.languageCode == 'ar'
                                      ? countriesNameAr
                                      : countriesName,
                                  buttonValues: countriesId,

                                  radioButtonValue: (value) {
                                    controller.country = value.toString();
                                  },
                                  // defaultSelected: ["Monday"],
                                  horizontal: false,
                                  width: 120,
                                  // hight: 50,
                                  selectedColor: redColor,

                                  padding: 5,
                                  spacing: 0.0,
                                  enableShape: true,
                                ),
                                SizedBox(height: 8),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 6),
                                Text(
                                  'home.genres'.tr,
                                  style: heading.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomCheckBoxGroup(
                                  unSelectedColor: Colors.white,

                                  buttonLables: controller.getNames(
                                      controller.genres, true),
                                  buttonValuesList:
                                  controller.getId(controller.genres),
                                  checkBoxButtonValues: (values) {
                                    controller.selectedGenres =
                                        values.join(',');
                                  },
                                  // defaultSelected: ["Monday"],
                                  horizontal: false,
                                  width: 120,
                                  // hight: 50,
                                  selectedColor: redColor,

                                  padding: 5,
                                  spacing: 0.0,
                                  enableShape: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 6),
                                Text(
                                  'filter.companies'.tr,
                                  style: heading.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomRadioButton(
                                  unSelectedColor: Colors.white,

                                  buttonLables:
                                  controller.getNames(controller.companies),
                                  buttonValues:
                                  controller.getId(controller.companies),
                                  radioButtonValue: (value) {
                                    controller.selectedStudios =
                                        value.toString();
                                  },
                                  // defaultSelected: ["Monday"],
                                  horizontal: false,
                                  width: 120,
                                  // hight: 50,
                                  selectedColor: redColor,

                                  padding: 5,
                                  spacing: 0.0,
                                  enableShape: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 6),
                                Text(
                                  'filter.certifications'.tr,
                                  style: heading.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomRadioButton(
                                  unSelectedColor: Colors.white,

                                  buttonLables: [
                                    "G",
                                    "PG",
                                    "PG-13",
                                    "R",
                                    "NC-17",
                                    "NR"
                                  ],
                                  buttonValues: [
                                    "G",
                                    "PG",
                                    "PG-13",
                                    "R",
                                    "NC-17",
                                    "NR"
                                  ],
                                  radioButtonValue: (value) {
                                    controller.selectedCert = value.toString();
                                  },
                                  // defaultSelected: ["Monday"],
                                  horizontal: false,
                                  width: 120,
                                  // hight: 50,
                                  selectedColor: redColor,

                                  padding: 5,
                                  spacing: 0.0,
                                  enableShape: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      fixedSize: Size(160, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 2.0))),
                                  child: Text('filter.reset'.tr),
                                  onPressed: () {
                                    controller.search(true);
                                    Navigator.of(context).pop();
                                    (context as Element).markNeedsBuild();
                                  },
                                ),
                                SizedBox(width: 5),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: redColor,
                                      fixedSize: Size(160, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 2.0))),
                                  child: Text('filter.apply'.tr),
                                  onPressed: () {
                                    controller.search();
                                    Navigator.of(context).pop();
                                    (context as Element).markNeedsBuild();


                                    //refresh();
                                    // Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      })
                }),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              body: GetBuilder<AllMoviesController>(
                builder: (_) {
                  return CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: controller.scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: StreamBuilder<List<MovieModel>>(
                            stream: controller.repo.streamController,
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
                                          ...controller.repo.movies
                                              .map((movie) => new BackdropPoster(
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
                                              rate: 9))
                                              .toList()
                                        ],
                                      )
                                          : GridView(
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                        ),
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          ...controller.repo.movies
                                              .map((movie) => Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: new BackdropPoster(
                                                  poster: movie.poster!,
                                                  backdrop: movie.backdrop!,
                                                  name: movie.title!,
                                                  date: movie.release_date!,
                                                  id: movie.id!,
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
                                              style: normalText.copyWith(
                                                  color: Colors.white),
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
                  );
                }
              )

            ),
          )),
    );
  }
}

