import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/core/model/people.model.dart';
import 'package:moviebox/core/streams/people_stream.dart';

import '../../themes.dart';


class PeopleResultSearchView extends StatefulWidget {
  final String query;
  final int count;

  const PeopleResultSearchView({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);

  @override
  _PeopleResultSearchViewState createState() => _PeopleResultSearchViewState();
}

class _PeopleResultSearchViewState extends State<PeopleResultSearchView> {
  PeopleResultSearchStream repo = PeopleResultSearchStream();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(PeopleResultSearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      repo = new PeopleResultSearchStream();
      repo.addData(widget.query);
    }
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (repo.people.length != widget.count) {
        repo.getNextMovies(widget.query);
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
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<List<PeopleModel>>(
                stream: repo.controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: Column(
                        children: [
                          GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 9 / 16),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              ...repo.people
                                  .map((p) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            //go to people details
                                          /*  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => BlocProvider(
                                                              create: (context) =>
                                                                  CastMoviesBloc()
                                                                    ..add(LoadCastInfo(
                                                                        id: p
                                                                            .id)),
                                                              child:
                                                                  CastPersonalInfoScreen(
                                                                image: p.profile,
                                                                title: p.name,
                                                              ),
                                                            )));*/
                                          },
                                          child: Container(
                                            constraints:
                                                BoxConstraints(minHeight: 280),
                                            child: Column(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: p.profile,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                                SizedBox(height: 5),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        p.name,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style:
                                                            normalText.copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness.dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList()
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (repo.people.length != widget.count)
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
    );
  }
}
