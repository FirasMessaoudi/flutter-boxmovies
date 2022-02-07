import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_info.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_bloc.dart';
import 'package:moviebox/src/core/bloc/cast_info/cast_movies_event.dart';
import 'package:moviebox/src/core/streams/people_stream.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/widget/favorite_button/cubit/fav_cubit.dart';
import 'package:moviebox/src/shared/widget/favorite_button/fav_button.dart';

import '../../../themes.dart';

class AddCastToFav extends StatefulWidget {
  @override
  State<AddCastToFav> createState() => _AddCastToFavState();
}

class _AddCastToFavState extends State<AddCastToFav> {
  GetSearchResultsPeople repo = GetSearchResultsPeople();
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
    repo = new GetSearchResultsPeople();
    repo.addData(query);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular celebrities"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: TextField(
            style: normalText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "Search",
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
                            itemCount: repo.people.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) =>
                                                CastMoviesBloc()
                                                  ..add(LoadCastInfo(
                                                      id: repo
                                                          .people[index].id)),
                                            child: CastPersonalInfoScreen(
                                              image: repo.people[index].profile,
                                              title: repo.people[index].name,
                                            ),
                                          )));
                                },
                                leading:
                                    Image.network(repo.people[index].profile),
                                title: Text(repo.people[index].name),
                                trailing: BlocProvider(
                                  create: (context) => FavMovieCubit()
                                    ..init(repo.people[index].id),
                                  child: FavIcon(
                                    type: FavType.person,
                                    title: repo.people[index].name,
                                    movieid: repo.people[index].id,
                                    poster: repo.people[index].profile,
                                    date: '',
                                    rate: 0.0,
                                    age: '',
                                    color: redColor,
                                    isEpisode: true,
                                    backdrop: repo.people[index].profile,
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
