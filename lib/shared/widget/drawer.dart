import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/shared/util/theme_switch.dart';
import 'package:moviebox/shared/widget/custom_app_bar.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';

import 'package:moviebox/ui/home/all_movies/all_movies.ui.dart';
import 'package:moviebox/ui/home/all_tv_show/all_shows.ui.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';
import 'package:moviebox/ui/profile/language_widget.dart';
import 'package:wiredash/wiredash.dart';

class DrawerUi extends StatelessWidget {
  AuthService authService = Get.find();
  final MyTheme myTheme = MyTheme();
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.movie,
            text: 'home.movies'.tr,
            action: 'movie',
            context: context,
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.tv,
            text: 'home.series'.tr,
            action: 'tv',
            context: context,
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.feedback,
            text: 'home.feedback'.tr,
            action: 'feedback',
            context: context,
          ),
          Divider(),
          if (FirebaseAuth.instance.currentUser?.uid == null)
            _createDrawerItem(
              icon: Icons.login,
              text: 'login.login'.tr,
              action: 'login',
              context: context,
            ),
          _createThemeItem(),
          Divider(),
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
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Image.asset(
        'assets/img/logo5.png',
        width: 50,
        height: 100,
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required String action,
      required BuildContext context}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: () async {
        if (action == 'feedback') Wiredash.of(context)!.show();
        if (action == 'login') {
        Get.toNamed(AppRoutes.login);
        }
        if (action == 'logout') {
          await authService.signOut();
          Navigator.pop(context);
        }
        if (action == 'movie') {
          Get.toNamed(AppRoutes.allMovies);
          AllMoviesController.instance.onInit();
        }
        if (action == 'tv') {
          Get.toNamed(AppRoutes.allTvShow);
          AllTvShowsController.instance.onInit();
        }
      },
    );
  }

  Widget _createThemeItem() {
    return ListTile(
        title: Row(
          children: <Widget>[
            Icon(Get.isDarkMode
                ? Icons.wb_sunny
                : Icons.brightness_3),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(Get.isDarkMode
                  ? 'edit_profile.light_mode'.tr
                  : 'edit_profile.dark_mode'.tr),
            )
          ],
        ),
        onTap: () async {
          myTheme.switchTheme();
          Get.changeThemeMode(Get.isDarkMode?ThemeMode.light:ThemeMode.dark);
        });
  }
}
