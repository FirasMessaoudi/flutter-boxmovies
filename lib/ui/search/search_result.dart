import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/ui/search/search_result_movie.dart';
import 'package:moviebox/ui/search/search_result_people.dart';
import 'package:moviebox/ui/search/search_result_tv.dart';
import '../../themes.dart';

class SearchResult extends StatefulWidget {
  final String id;
  final String title;

  const SearchResult({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: TabBar(
                indicatorColor: redColor,
                labelStyle: normalText.copyWith(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black),
                labelColor: Get.isDarkMode
                    ? Colors.white
                    : Colors.black,
                labelPadding: EdgeInsets.only(top: 10.0),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'home.movies'.tr,
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'home.series'.tr,
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'movie_info.cast'.tr,
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MovieResultSearchView(
                  query: widget.id.toString(),
                ),
                TvShowsResultSearchView(
                  query: widget.id.toString(),
                ),
                PeopleResultSearchView(query: widget.id,count: 200,)
              ],
            ),
          )),
    );
  }
}
