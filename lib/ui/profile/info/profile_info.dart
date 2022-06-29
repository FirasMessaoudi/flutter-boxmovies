import 'package:decorated_icon/decorated_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/bloc/collection_tab/collection_tab_bloc.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/core/model/user.model.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/util/profile_list_items.dart';
import 'package:moviebox/shared/widget/image_view.dart';
import 'package:moviebox/ui/collection/collection_tab.dart';
import 'package:moviebox/ui/favorite/favorite_tab.dart';
import 'package:moviebox/ui/profile/edit/edit_profile.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';
import 'package:moviebox/ui/watchlist/movies/watchlist_tab.dart';
import 'package:moviebox/ui/watchlist/tv/watchlist_tv_tab.dart';

import '../../../themes.dart';

class ProfileInfoView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {},
                icon: DecoratedIcon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            )
          ],
          leading: IconButton(
            icon: DecoratedIcon(
              Icons.arrow_back_sharp,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Obx(()=> controller.isLoading.isTrue?
               Center(child: CircularProgressIndicator(color: Colors.red),)
                  :RefreshIndicator(
                  child:SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewPhotos(
                                            imageList: [
                                              ImageBackdrop(
                                                  image: controller.user.value.cover),
                                            ],
                                            imageIndex: 0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                  },
                                  child: Container(
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: (controller.user.value.cover !=
                                                        null &&
                                                    controller.user.value.cover != '')
                                                ? NetworkImage(
                                                        controller.user.value.cover)
                                                    as ImageProvider
                                                : AssetImage(
                                                    'assets/img/adventure.jpg'))),
                                  ),
                                ))
                              ],
                            ),
                            Positioned(
                                top: 170.0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.user.value.photo != null ||
                                        FirebaseAuth.instance.currentUser!.photoURL != null)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewPhotos(
                                            imageList: [
                                              ImageBackdrop(
                                                  image: controller.user.value.photo !=
                                                          null
                                                      ? controller.user.value.photo
                                                      : FirebaseAuth.instance.currentUser!.photoURL),
                                            ],
                                            imageIndex: 0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                  },
                                  child: Container(
                                    height: 130.0,
                                    width: 130.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: controller.user.value.photo != null
                                              ? NetworkImage(
                                                  controller.user.value.photo)
                                              : FirebaseAuth.instance.currentUser!.photoURL != null
                                                  ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL??'')
                                                  : AssetImage(
                                                          'assets/img/avatarprofile.png')
                                                      as ImageProvider,
                                        ),
                                        border: Border.all(
                                            color: Colors.white, width: 3.0)),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            controller.user.value.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Container(
                          child: Text(
                        controller.user.value.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Spectral',
                            fontStyle: FontStyle.italic),
                      )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20.0),
                        clipBehavior: Clip.antiAlias,
                        // color: Colors.grey,
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "info_user.episode_watched".tr,
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                     controller.nbWatchedEpisodes.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        // color: Colors.pinkAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "info_user.time_spent".tr,
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      controller.period,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        // color: Colors.pinkAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Column(children: <Widget>[
                          ProfileListItem(
                            icon: Icons.favorite,
                            text: 'info_user.fav'.tr,
                            item: ProfileItems.fav,
                            user: controller.user.value,
                            count: controller.nbCountFav,
                          ),
                          ProfileListItem(
                              icon: Icons.tv,
                              text: 'info_user.my_shows'.tr,
                              item: ProfileItems.series,
                              user: controller.user.value,
                              count: controller.nbCountTv),
                          ProfileListItem(
                              icon: Icons.movie,
                              text: 'info_user.my_movies'.tr,
                              item: ProfileItems.movies,
                              user: controller.user.value,
                              count: controller.nbCountMovies),
                          ProfileListItem(
                              icon: Icons.list,
                              text: 'info_user.custom_lists'.tr,
                              item: ProfileItems.collections,
                              user: controller.user.value,
                              count: controller.nbCountCollections),
                          ProfileListItem(
                            icon: Icons.legend_toggle,
                            text: 'info_user.stat'.tr,
                            item: ProfileItems.stat,
                            user: controller.user.value,
                          ),
                          ProfileListItem(
                            icon: Icons.settings,
                            text: 'info_user.settings'.tr,
                            item: ProfileItems.settings,
                            user: controller.user.value,
                          ),
                          ProfileListItem(
                            icon: Icons.logout,
                            text: 'info_user.logout'.tr,
                            item: ProfileItems.logout,
                            hasNavigation: false,
                            user: controller.user.value,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                      onRefresh:(){
                        return Future.delayed(Duration(seconds: 1),
                                (){
                              controller.initialization();
                            }
                        );
                      }
                  ))
              );
  }
}

class ProfileListItem extends GetView<ProfileController> {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final ProfileItems item;
  final MyUser user;
  final int? count;

  const ProfileListItem(
      {Key? key,
      required this.icon,
      required this.text,
      required this.item,
      this.hasNavigation = true,
      this.count,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!this.hasNavigation) {
         await controller.logout();
        }
        if (item == ProfileItems.settings) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => new EditProfile()));
        }
        if (item == ProfileItems.movies) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => new WatchlistTab(type: item)));
        }
        if (item == ProfileItems.series) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new WatchListTvTab()));
        }
        if (item == ProfileItems.fav) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new FavoritesTab()));
        }
        if (item == ProfileItems.collections) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<CollectionTabBloc>(
              create: (context) => CollectionTabBloc()..add(LoadCollections()),
              child: CollectionsTab(),
            ),
          ));
        }
      },
      child: Container(
        height: 55,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 20,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
            border: Border.all(
                color: Get.isDarkMode
                    ? Colors.white
                    : Colors.black,
                width: 1)),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: 25,
            ),
            SizedBox(width: 15),
            Text(
              this.count == null ? this.text : this.text + '   ($count)',
              style: kTitleTextStyle.copyWith(
                  fontWeight: FontWeight.w500, fontFamily: "Poppins"),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                Icons.arrow_right,
                size: 25,
              ),
          ],
        ),
      ),
    );
  }
}
