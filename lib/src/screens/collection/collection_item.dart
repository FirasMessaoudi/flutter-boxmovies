import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/repo/collection_repo.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/star_icon.dart';

import '../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';

class CollectionItem extends StatelessWidget{
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final String deviceId;
  final String collectionName;
  const CollectionItem({Key? key, required this.doc,required this.deviceId,required this.collectionName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
             child: GestureDetector(
                onTap: (){
                  moveToInfo(context, doc['isMovie'], doc['id'], doc['backdrop'], doc['name']);
                },
                child: Container(
                  color: Colors.grey.shade900,
                  child: CachedNetworkImage(
                    imageUrl: doc['image'],
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              )

            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            doc['name'],
                            style: heading.copyWith(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          Text(doc['date'],
                              style: normalText
                                  .copyWith(
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                "  " +
                                    doc['rate']
                                        .toString() +
                                    "/10",
                                style: normalText
                                    .copyWith(

                                  letterSpacing:
                                  1.2,
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 9),
                          OutlinedButton(
                            onPressed: () {
                              {
                                FirebaseFirestore.instance
                                    .collection(
                                    'UserCollections')
                                    .doc(deviceId)
                                    .collection(
                                    'Collections')
                                    .doc(collectionName)
                                    .collection(
                                    'movies & Tv')
                                    .doc(doc['id'])
                                    .delete();
                              }
                            },
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black) // side: Bord
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 20,
                                  color: redColor,
                                ),
                                Text(

                                  "my_list.remove_from_collection".tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}