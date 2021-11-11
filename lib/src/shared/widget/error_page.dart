import 'package:flutter/material.dart';
import 'package:moviebox/src/screens/cast/add_cast_to_fav.dart';
import 'package:moviebox/src/screens/watchlist/add_to_watchlist_fav.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';

import '../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              size: 45,
              color: Colors.white.withOpacity(.6),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Something wants wrong!",
              style: heading.copyWith(color: Colors.white.withOpacity(.9)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We're so sorry about the error.please try again later.",
              textAlign: TextAlign.center,
              style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyFavorites extends StatelessWidget {
  final bool isMovie;
  final FavType type;
  const EmptyFavorites({Key? key, required this.isMovie, required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: (){
                if(type!=FavType.person)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => new AddToLWatchlistFav(
                        isMovie: isMovie, action: ProfileItems.fav)));
                else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new AddCastToFav(
                          )));
                }
              },
              icon:Icon(
              Icons.favorite,
              size: 45),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "my_list.empty_favorite_title".tr(),
              style: heading.copyWith(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "my_list.empty_favorite_message".tr(),
              textAlign: TextAlign.center,
              style: normalText.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}

class Emptywatchlist extends StatelessWidget {
  final bool isMovie;

  const Emptywatchlist({Key? key, required this.isMovie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => new AddToLWatchlistFav(
                        isMovie: isMovie, action: ProfileItems.movies)));
              },
              icon:Icon(
                  Icons.bookmark_add,
                  size: 45),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "my_list.empty_watchlist_title".tr(),
              style: heading.copyWith(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "my_list.empty_watchlist_message".tr(),
              textAlign: TextAlign.center,
              style: normalText.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}