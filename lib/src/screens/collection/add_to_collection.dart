import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moviebox/src/shared/widget/collection_button/cubit/add_collection_cubit.dart';
import 'package:moviebox/src/shared/widget/collection_button/cubit/add_collection_state.dart';

import '../../../themes.dart';

class AddToCollection extends StatelessWidget {
  final String title;
  final String date;
  final String devid;
  final String image;
  final String backdrop;
  final bool isMovie;
  final double rate;
  final String movieid;
  final bool justIcon;

  AddToCollection(
      {Key? key,
      required this.title,
      required this.date,
      required this.rate,
      required this.devid,
      required this.image,
      required this.backdrop,
      required this.isMovie,
      required this.movieid,
      required this.justIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController con = TextEditingController();
    return BlocBuilder<CollectionCubit, CollectionState>(
        builder: (context, state) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "my_list.my_collections".tr(),
              style: heading,
            ),
            elevation: 0,
          ),
          body: Container(
              child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: RaisedButton(
                  color: redColor,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                              "my_list.collection_name".tr(),
                              style: heading.copyWith(
                                //color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            content: TextField(
                              controller: con,
                              cursorColor: redColor,
                              style: heading.copyWith(fontSize: 24),
                              autofocus: true,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: redColor, width: 2))),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "my_list.btn_cancel".tr(),
                                  style: normalText.copyWith(fontSize: 15),
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    //add to new collection
                                    BlocProvider.of<CollectionCubit>(context)
                                        .addToNewCollection(
                                            devid,
                                            con.text,
                                            movieid,
                                            title,
                                            image,
                                            rate,
                                            date,
                                            backdrop,
                                            isMovie);
                                    Navigator.pop(context, true);
                                    Navigator.pop(context, true);
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                      msg: 'my_list.added_to_collection'.tr() +
                                          con.text,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                  },
                                  child: Text("my_list.create_add".tr(),
                                      style: normalText.copyWith(
                                          color: redColor, fontSize: 15)))
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                      ),
                      Text(
                        "my_list.new_collection".tr(),
                        style: normalText.copyWith(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('UserCollections')
                      .doc(devid)
                      .collection('CollectionInfo')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snp) {
                    if (snp.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          ...snp.data!.docs
                              .map((coll) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () async {
                                        //existing collection
                                        await BlocProvider.of<CollectionCubit>(
                                                context)
                                            .addToExistingCollection(
                                                devid,
                                                coll['name'],
                                                movieid,
                                                title,
                                                image,
                                                backdrop,
                                                rate,
                                                date,
                                                isMovie);
                                        Fluttertoast.showToast(
                                          msg:
                                              "Added to collection ${coll['name']}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                        Navigator.pop(context, true);
                                        Navigator.of(context).pop();
                                      },
                                      leading: Image.network(coll['image']),
                                      title: Text(
                                        coll['name'],
                                        style: normalText.copyWith(),
                                      ),
                                    ),
                                  ))
                              .toList()
                        ],
                      );
                    } else if (!snp.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  })
            ],
          )),
        ),
      );
    });
  }
}
