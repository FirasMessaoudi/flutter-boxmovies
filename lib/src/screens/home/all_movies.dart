import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/genres_model.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/network.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/core/streams/all_movies_stream.dart';
import 'package:moviebox/src/shared/util/constant.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/backdrop.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../themes.dart';

class Movies extends StatelessWidget {

  //final GlobalKey<_AllMoviesWidgetState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
          initialIndex: 0,
          length: 1,
          child: Scaffold(

            appBar: AppBar(
              elevation: 0,
              brightness: Theme
                  .of(context)
                  .brightness,
              title: Text('discover.browse_all'.tr(),
                  style: heading.copyWith(color: Theme
                      .of(context)
                      .brightness == Brightness.dark ? Colors.white : Colors
                      .black)),
              bottom: TabBar(
                indicatorColor: redColor,
                labelStyle: normalText.copyWith(color: Theme
                    .of(context)
                    .brightness == Brightness.dark ? Colors.white : Colors
                    .black),
                labelColor: Theme
                    .of(context)
                    .brightness == Brightness.dark ? Colors.white : Colors
                    .black,
                labelPadding: EdgeInsets.only(top: 10.0),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'home.movies'.tr(),
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AllMoviesWidget(
                  results: 200,

                ),
              ],
            ),
          )),
    );
  }

}


class AllMoviesWidget extends StatefulWidget {
  final int results;
  const AllMoviesWidget({
    Key? key,
    required this.results,

  }) : super(key: key);
  @override
  _AllMoviesWidgetState createState() => _AllMoviesWidgetState();

}

class _AllMoviesWidgetState extends State<AllMoviesWidget> {
   AllMoviesStream repo = AllMoviesStream();
  ScrollController controller = ScrollController();
  String globalQuery='';
   final genres = GenresList.fromJson(genreslist).list;
   final companies = NetworksList.fromJson(companylist).list;
   final List<String> sortListLabels = [
     "filter.popularity".tr(),
     "filter.vote".tr(),
     "Box Office",
   ];
   final List<String> sortListValues = [
     "popularity.desc",
     "vote_average.desc",
     "revenue.desc",
   ];
   String selectedGenres = '';
   String selectedStudios = '';
   String selectedCert ='';
   String sortBy = '';
   String country = '';
  @override
  void initState() {
    super.initState();
    repo.addData(globalQuery);
    controller.addListener(_scrollListener);
  }
   List<String> getId(list) {
     List<String> ids = [];
     for (int i = 0; i < list.length; i++) ids.add(list[i].id);

     return ids;
   }

   List<String> getNames(list) {
     List<String> names = [];
     for (int i = 0; i < list.length; i++) names.add(list[i].name);
     return names;
   }

  void refresh  ([bool reset=false]) async {
    //repo.dispose();
    repo = new AllMoviesStream();
    if(reset==true){
      repo.addData('');
    }
    repo.addData(makeQuery());
    sortBy='';
    selectedCert='';
    selectedStudios='';
    selectedGenres='';
    country = '';
  }
  makeQuery (){
    String query='';
    if(sortBy!=''){
      query+='&sort_by=$sortBy';
    }
    if(selectedStudios!=''){
      query+='&with_companies=$selectedStudios';
    }
    if(selectedGenres!=''){
      query+='&with_genres=$selectedGenres';
    }
    if(selectedCert!=''){
      query+='&certification_country=US&certification=$selectedCert';
    }
    if(country!=''){
      query+='&with_original_language=$country';
    }
    globalQuery = query;
    return globalQuery;
  }
  void _scrollListener() {
    print(repo.isfinish);
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {

      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(globalQuery);
      }
    }
  }

  @override
  void dispose() {
    repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
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
                              'filter.sort_by'.tr(),
                              style: heading.copyWith(
                                fontSize: 15,
                                color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomRadioButton(
                              unSelectedColor:Colors.white,

                              buttonLables: sortListLabels,
                              buttonValues: sortListValues,

                              radioButtonValue: (value) {
                                print(value);
                                this.sortBy = value.toString();
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
                              'filter.countries'.tr(),
                              style: heading.copyWith(
                                fontSize: 15,
                                color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomRadioButton(
                              unSelectedColor:Colors.white,

                              buttonLables: countriesName,
                              buttonValues: countriesId,

                              radioButtonValue: (value) {
                                this.country = value.toString();
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
                              'home.genres'.tr(),
                              style: heading.copyWith(
                                fontSize: 15,
                                color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomCheckBoxGroup(
                              unSelectedColor:Colors.white,

                              buttonLables: getNames(genres),
                              buttonValuesList: getId(genres),
                              checkBoxButtonValues: (values) {
                                print(values);
                                this.selectedGenres = values.join(',');
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
                              'filter.companies'.tr(),
                              style: heading.copyWith(
                                fontSize: 15,
                                color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomRadioButton(
                              unSelectedColor:Colors.white,

                              buttonLables: getNames(companies),
                              buttonValues: getId(companies),
                              radioButtonValue: (value) {
                                print(value);
                                this.selectedStudios = value.toString();
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
                              'filter.certifications'.tr(),
                              style: heading.copyWith(
                                fontSize: 15,
                                color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomRadioButton(
                              unSelectedColor:Colors.white,

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
                                print(value);
                                this.selectedCert = value.toString();
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
                                          color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                          width: 2.0))),
                              child: Text('filter.reset'.tr()),
                              onPressed: () {
                                setState(() {
                                  refresh(true);
                                  Navigator.of(context).pop();
                                });
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
                                          color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                          width: 2.0))),
                              child: Text('filter.apply'.tr()),
                              onPressed: () {
                                setState(() {
                                  refresh();
                                  Navigator.of(context).pop();
                                });
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
    body: CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<MovieModel>>(
              stream: repo.controller.stream,
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
                                  ...repo.movies
                                      .map((movie) => new BackdropPoster(
                                          poster: movie.poster,
                                          backdrop: movie.backdrop,
                                          name: movie.title,
                                          date: movie.release_date,
                                          id: movie.id,
                                          color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
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
                                  ...repo.movies
                                      .map((movie) => Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: new BackdropPoster(
                                              poster: movie.poster,
                                              backdrop: movie.backdrop,
                                              name: movie.title,
                                              date: movie.release_date,
                                              id: movie.id,
                                              color: Colors.white,
                                              isMovie: true,
                                              rate: 9)))
                                      .toList()
                                ],
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!repo.isfinish)
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
    ));
  }
}
