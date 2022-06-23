import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/core/bloc/collection_tab/collection_tab_bloc.dart';
import 'package:moviebox/core/service/collection.service.dart';
import 'package:moviebox/shared/widget/empty_collection.dart';

import '../../themes.dart';
import 'add_to_empty_collection.dart';
import 'collection_info.dart';

class CollectionsTab extends StatefulWidget {
  @override
  _CollectionsTabState createState() => _CollectionsTabState();
}

class _CollectionsTabState extends State<CollectionsTab> {
  final repo = CollectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("my_list.my_collections".tr),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new AddToEmptyCollection()));
                },
                icon: Icon(Icons.add))
          ],
          leadingWidth: 10,
        ),
        body: BlocBuilder<CollectionTabBloc, CollectionTabState>(
          builder: (context, state) {
            if (state is CollectionTabLoading) {
              return Container(
                child: Center(
                    child: CircularProgressIndicator(
                  color: redColor,
                )),
              );
            } else if (state is CollectionTabLoaded) {
              if (state.collections.isNotEmpty) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      GridView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 10 / 18),
                        children: [
                          for (var i = 0; i < state.collections.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return new AlertDialog(
                                          title: new Text(
                                              "my_list.confirm_delete_collection"
                                                  .tr,
                                              style: normalText.copyWith()),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                    "my_list.btn_cancel".tr,
                                                    style:
                                                        normalText.copyWith())),
                                            TextButton(
                                                onPressed: () async {
                                                  var newid = await FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid;

                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'UserCollections')
                                                        .doc(newid)
                                                        .collection(
                                                            'Collections')
                                                        .doc(state
                                                            .collections[i]
                                                            .name)
                                                        .delete();
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'UserCollections')
                                                        .doc(newid)
                                                        .collection('allMovies')
                                                        .where('inCollection',
                                                            isEqualTo: state
                                                                .collections[i]
                                                                .name)
                                                        .get()
                                                        .then((value) async {
                                                      for (var coll
                                                          in value.docs) {
                                                        await coll.reference
                                                            .delete();
                                                      }
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'UserCollections')
                                                        .doc(newid)
                                                        .collection(
                                                            'CollectionInfo')
                                                        .doc(state
                                                            .collections[i]
                                                            .name)
                                                        .delete();
                                                    setState(() {
                                                      state.collections
                                                          .removeAt(i);
                                                    });
                                                    Navigator.of(context).pop();
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }
                                                },
                                                child: Text(
                                                  "my_list.btn_remove".tr,
                                                  style: normalText.copyWith(
                                                    color: redColor,
                                                  ),
                                                ))
                                          ],
                                        );
                                      });
                                },
                                onTap: () async {
                                  var newid = await FirebaseAuth
                                      .instance.currentUser!.uid;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CollectionInfo(
                                          collectionName:
                                              state.collections[i].name,
                                          deviceId: newid,
                                          image: state.collections[i].image,
                                          date: state.collections[i].time)));
                                },
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: CachedNetworkImage(
                                          imageUrl: state.collections[i].image,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        state.collections[i].name,
                                        style: normalText.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        state.collections[i].time,
                                        style: normalText.copyWith(
                                            // color: Colors.white.withOpacity(.8),
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return EmptyCollections();
              }
            } else {
              return Container();
            }
          },
        ));
  }
}
