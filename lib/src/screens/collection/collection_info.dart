import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../themes.dart';
import 'add_to_empty_collection.dart';
import 'collection_item.dart';

class CollectionInfo extends StatefulWidget {
  CollectionInfo(
      {Key? key,
      required this.deviceId,
      required this.collectionName,
      required this.image,
      required this.date})
      : super(key: key);
  final String deviceId;
  final String collectionName;
  final String image;
  final String date;

  @override
  State<CollectionInfo> createState() => _CollectionInfoState();
}

class _CollectionInfoState extends State<CollectionInfo> {
  late TextEditingController con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
              pinned: true,
              expandedHeight: 340,
              stretch: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => new AddToEmptyCollection()));
                    },
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.collectionName,
                  style: heading.copyWith(
                      //color: Colors.white,
                      ),
                ),
                stretchModes: [
                  StretchMode.fadeTitle,
                  StretchMode.zoomBackground
                ],
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          widget.image))),
                            ),
                            SizedBox(height: 10),
                            Text(
                                'my_list.created_on'.tr() +
                                    widget.date.toUpperCase(),
                                style: normalText.copyWith(
                                    color: Colors.white, fontSize: 12))
                          ],
                        ),
                      ),
                    )),
              )),
          SliverToBoxAdapter(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserCollections')
                    .doc(widget.deviceId)
                    .collection('Collections')
                    .doc(widget.collectionName)
                    .collection('movies & Tv')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snp) {
                  if (!snp.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          color: redColor,
                        ),
                      ),
                    );
                  } else if (snp.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ...snp.data!.docs
                            .map((doc) => CollectionItem(
                                  doc: doc,
                                  deviceId: widget.deviceId,
                                  collectionName: widget.collectionName,
                                ))
                            .toList()
                      ],
                    );
                  } else {
                    return Container(
                        child: Text('No items in this collection'));
                  }
                }),
          )
        ],
      ),
    );
  }
}
