import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/tv_show.model.dart';
import 'package:moviebox/shared/util/constant.dart';
import 'package:moviebox/shared/widget/appbar.dart';
import 'package:moviebox/shared/widget/backdrop.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';

import '../../../themes.dart';

class AllTvShowView extends GetView<AllTvShowsController> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: DefaultAppBar(title: 'home.series'.tr),
        body: Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: Get.isDarkMode ? Colors.white : Colors.black,
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
                                        print(value);
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
                                      buttonLables:
                                          Get.locale!.languageCode == 'ar'
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
                                          controller.genreList, true),
                                      buttonValuesList:
                                          controller.getId(controller.genreList,true),
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
                                      'filter.networks'.tr,
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

                                      buttonLables: controller
                                          .getNames(controller.networks),
                                      buttonValues:
                                          controller.getId(controller.networks),
                                      radioButtonValue: (value) {
                                        print(value);
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
                                        controller.selectedCert =
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
            body: GetBuilder<AllTvShowsController>(builder: (_) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: _.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StreamBuilder<List<TvModel>>(
                        stream: _.repo.controller.stream,
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
                                            ..._.repo.shows
                                                .map((movie) =>
                                                    new BackdropPoster(
                                                        poster: movie.poster!,
                                                        backdrop:
                                                            movie.backdrop!,
                                                        name: movie.title!,
                                                        date:
                                                            movie.release_date!,
                                                        id: movie.id!,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        isMovie: false,
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
                                            ..._.repo.shows
                                                .map((movie) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: new BackdropPoster(
                                                        poster: movie.poster!,
                                                        backdrop:
                                                            movie.backdrop!,
                                                        name: movie.title!,
                                                        date:
                                                            movie.release_date!,
                                                        id: movie.id!,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        isMovie: false,
                                                        rate: 9)))
                                                .toList()
                                          ],
                                        ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (!_.repo.isfinish)
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
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black),
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
            })),
      ),
    );
  }
}
