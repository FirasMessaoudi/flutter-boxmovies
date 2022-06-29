import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/shared/util/profile_list_items.dart';
import 'package:moviebox/ui/watchlist/add_to_watchlist_fav.dart';


class EmptyPoster extends StatelessWidget {
  final bool isMovie;
  final ProfileItems action;

  const EmptyPoster({
    Key? key,
    required this.isMovie,
    required this.action,
  }) : super(key: key);

  moveToInfo(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            new AddToLWatchlistFav(isMovie: isMovie, action: action)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            moveToInfo(context);
          },
          child: Container(
            constraints: BoxConstraints(minHeight: 280),
            child: Column(
              children: [
                Container(
                    height: 200,
                    width: 130,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    // color: Colors.grey.shade900,

                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                moveToInfo(context);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('my_list.add_to_list'.tr,
                                textAlign: TextAlign.center)
                          ],
                        )

                        // Image.network(
                        //   poster,
                        //   fit: BoxFit.cover,
                        // ),
                      ],
                      // borderRadius: BorderRadius.circular(10.0),
                      // child: CachedNetworkImage(
                      //   imageUrl: poster,
                      //   fit: BoxFit.cover,
                      // ),
                    )),
              ],
            ),
          ),
          // ),
        ));
  }
}
