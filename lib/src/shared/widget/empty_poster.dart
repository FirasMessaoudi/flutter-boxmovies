import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/screens/watchlist/add_to_watchlist_fav.dart';
import 'package:moviebox/src/shared/util/animation.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_event.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/src/shared/widget/watchlist_button/widget/watchlist_icon.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyPoster extends StatelessWidget {
  final bool isMovie;
  final ProfileItems action;
  const EmptyPoster({
    Key? key,
    required this.isMovie, required this.action,
  }) : super(key: key);
  moveToInfo(BuildContext context) {

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new AddToLWatchlistFav(
            isMovie: isMovie, action: action)));
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
                            Text('my_list.add_to_list'.tr(), textAlign: TextAlign.center)
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
    )
    );
  }
}
