import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/shared/util/theme_switch.dart';
import 'package:moviebox/shared/widget/drawer/bottom_user_info.dart';
import 'package:moviebox/shared/widget/drawer/custom_list_tile.dart';
import 'package:moviebox/shared/widget/drawer/header.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';
import 'package:moviebox/ui/profile/language_widget.dart';
import 'package:wiredash/wiredash.dart';

class CustomDrawer extends StatefulWidget {
   CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = true;
  AuthService authService = Get.find();
  final MyTheme myTheme = MyTheme();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration:  Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin:  EdgeInsets.only(bottom: 10, top: 10),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: context.theme.primaryColorLight
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDrawerHeader(isCollapsed: _isCollapsed),
               Divider(
                color: Colors.grey,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.movie,
                title: 'home.movies'.tr,
                infoCount: 0,
                onClickAction:() =>{ Get.toNamed(AppRoutes.allMovies),
              AllMoviesController.instance.onInit()},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.tv,
                title: 'home.series'.tr,
                infoCount: 0,
                onClickAction:() =>{ Get.toNamed(AppRoutes.allTvShow),
                  AllTvShowsController.instance.onInit()},
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.feedback,
                title: 'home.feedback'.tr,
                infoCount: 0,
                onClickAction: ()=>Wiredash.of(context)!.show(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.message_rounded,
                title: 'Messages',
                infoCount: 8,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.notifications,
                title: 'Notifications',
                infoCount: 2,
              ),
               Divider(color: Colors.grey),
               SizedBox(height: 15,),
              if(_isCollapsed)
              SettingsTile(
                  title: 'edit_profile.language'.tr,
                  subtitle: Get.locale!.languageCode == 'en'
                      ? 'English'
                      : Get.locale!.languageCode == 'ar'
                      ? 'Arabic'
                      : 'Français',
                  leading: Icon(Icons.language),
                  trailing: LanguageWidget()
              ),
            ListTile(
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Icon(Get.isDarkMode
                          ? Icons.wb_sunny
                          : Icons.brightness_3),
                      if(_isCollapsed)
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(Get.isDarkMode
                            ? 'edit_profile.light_mode'.tr
                            : 'edit_profile.dark_mode'.tr),
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  myTheme.switchTheme();
                  Get.changeThemeMode(Get.isDarkMode?ThemeMode.light:ThemeMode.dark);
                }),
              BottomUserInfo(isCollapsed: _isCollapsed),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Get.theme.primaryColorDark,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}