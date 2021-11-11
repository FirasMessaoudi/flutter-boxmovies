import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/model/movie_model.dart';
import 'package:moviebox/src/core/model/tv_model.dart';
import 'package:moviebox/src/core/streams/all_movies_stream.dart';
import 'package:moviebox/src/core/streams/collection_stream.dart';
import 'package:moviebox/src/core/streams/movies_stream.dart';
import 'package:moviebox/src/core/streams/tv_stream.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/collection_button/add_collection_button.dart';
import 'package:moviebox/src/shared/widget/collection_button/cubit/add_collection_cubit.dart';
import 'package:moviebox/src/shared/widget/favorite_button/cubit/fav_cubit.dart';
import 'package:moviebox/src/shared/widget/favorite_button/fav_button.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/widget/watchlist_icon.dart';

import '../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';

class AddToEmptyCollection extends StatefulWidget {
  @override
  State<AddToEmptyCollection> createState() => _AddToEmptyCollectionState();
}

class _AddToEmptyCollectionState extends State<AddToEmptyCollection> {
  CollectionStream repo = CollectionStream();
  ScrollController controller = ScrollController();
  String query = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    repo.addData(query);
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    repo.dispose();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(query);

        print("at the end of list");
      }
    }
  }

  void search() async {
    repo = new CollectionStream();
    repo.addData(query);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('my_list.collection_bar_title'.tr()),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: TextField(
            style: normalText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "discover.search".tr(),
                hintStyle: normalText,
                // fillColor: Colors.black,
                filled: true,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                )),
            onChanged: (value) => {
              query = value,
              setState(() {
                search();
              })
            },
          ),
        ),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 3.0, vertical: 10.0),
            child: StreamBuilder<List<dynamic>>(
              stream: repo.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data!.length);
                  // final movies = snapshot.data!;
                  return Container(
                    child: Column(
                      children: [
                        ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: repo.movies.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  moveToInfo(
                                      context,
                                      repo.movies[index] is MovieModel,
                                      repo.movies[index].id,
                                      repo.movies[index].backdrop,
                                      repo.movies[index].title);
                                },
                                leading:
                                    Image.network(repo.movies[index].poster),
                                title: Text(repo.movies[index].title),
                                trailing: BlocProvider(
                                  create: (context) => CollectionCubit()
                                    ..init(repo.movies[index].id),
                                  child: AddCollectionIcon(
                                    date: repo.movies[index].release_date,
                                    image: repo.movies[index].poster,
                                    isMovie: repo.movies[index] is MovieModel,
                                    rate: repo.movies[index].vote_average,
                                    title: repo.movies[index].title,
                                    movieid: repo.movies[index].id,
                                    likeColor: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black45,
                                    unLikeColor: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black45,
                                    backdrop: repo.movies[index].backdrop,
                                    justIcon: true,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black45);
                            }),
                        SizedBox(
                          height: 10,
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
                                style: normalText.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                      height: 500,
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        color: redColor,
                      )));
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
