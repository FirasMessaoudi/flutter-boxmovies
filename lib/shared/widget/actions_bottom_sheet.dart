import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/shared/util/fav_type.dart';
import 'package:moviebox/shared/widget/watchlist_button/state/watchlist_cubit.dart';
import 'package:moviebox/shared/widget/watchlist_button/widget/watchlist_icon.dart';
import 'package:share/share.dart';

import '../../themes.dart';
import 'collection_button/add_collection_button.dart';
import 'collection_button/cubit/add_collection_cubit.dart';
import 'favorite_button/cubit/fav_cubit.dart';
import 'favorite_button/fav_button.dart';

class ActionsBottomSheet extends StatelessWidget {
  ActionsBottomSheet(
      this.id,
      this.title,
      this.poster,
      this.releaseDate,
      this.isMovie,
      this.rate,
      this.image,
      this.textColor,
      this.type,
      this.homePage,
      this.age,
      this.genres);

  String? id;
  String? title;
  String? poster;
  String? releaseDate;
  bool? isMovie;
  double? rate;
  String? image;
  Color? textColor;
  FavType? type;
  String? homePage;
  String? age;
  List<int>? genres;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: ListView(
      shrinkWrap: true,
      children: [
        BlocProvider(
          create: (context) => WatchlistCubit()..init(id!, isMovie!),
          child: WatchListIcon(
              fromBottomSheet: true,
              title: title!,
              movieid: id!,
              poster: poster!,
              date: releaseDate!,
              rate: rate!,
              isMovie: isMovie!,
              color: textColor!,
              genres: genres,
              backdrop: image!),
        ),
        BlocProvider(
          create: (context) => CollectionCubit()..init(id!),
          child: AddCollectionIcon(
            date: releaseDate!,
            image: poster!,
            isMovie: isMovie!,
            rate: rate!,
            title: title!,
            movieid: id!,
            likeColor: textColor!,
            unLikeColor: textColor!,
            backdrop: image!,
          ),
        ),
        BlocProvider(
          create: (context) => FavMovieCubit()..init(id!),
          child: FavIcon(
              type: type!,
              title: title!,
              movieid: id!,
              poster: age != '' ? image! : poster!,
              date: releaseDate!,
              rate: rate!,
              age: age!,
              color: textColor!,
              genres: genres,
              backdrop: image!),
        ),
        ListTile(
          onTap: () {
            if (homePage != null) Share.share(homePage!);
          },
          leading: Icon(Icons.share, color: textColor),
          title: Text(
            'actions.share'.tr,
            style: normalText.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        )
      ],
    ));
  }
}
