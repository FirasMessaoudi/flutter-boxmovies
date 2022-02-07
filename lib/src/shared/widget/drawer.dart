import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/responsive/custom_app_bar.dart';
import 'package:moviebox/src/screens/auth/login_page.dart';
import 'package:moviebox/src/screens/home/all_movies.dart';
import 'package:moviebox/src/screens/home/all_shows.dart';
import 'package:moviebox/src/shared/util/theme_switch.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

class DrawerUi extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.movie,
            text: 'home.movies'.tr(),
            action: 'movie',
            context: context,
          ),
          _createDrawerItem(
            icon: Icons.tv,
            text: 'home.series'.tr(),
            action: 'tv',
            context: context,
          ),
          _createDrawerItem(
            icon: Icons.feedback,
            text: 'home.feedback'.tr(),
            action: 'feedback',
            context: context,
          ),
          Divider(),
          if (FirebaseAuth.instance.currentUser?.uid == null)
            _createDrawerItem(
              icon: Icons.login,
              text: 'login.login'.tr(),
              action: 'login',
              context: context,
            ),
          _createThemeItem(context),
          Divider(),
          DropdownScreen()
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
        }
        if (action == 'logout') {
          await _firebaseAuth.signOut();
          Navigator.pop(context);
        }
        if (action == 'movie') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Movies(),
          ));
        }
        if (action == 'tv') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TvShows(),
          ));
        }
      },
    );
  }

  Widget _createThemeItem(BuildContext context) {
    return ListTile(
        title: Row(
          children: <Widget>[
            Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.wb_sunny
                : Icons.brightness_3),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(Theme.of(context).brightness == Brightness.dark
                  ? 'edit_profile.light_mode'.tr()
                  : 'edit_profile.dark_mode'.tr()),
            )
          ],
        ),
        onTap: () async {
          Provider.of<MyTheme>(context, listen: false).switchTheme();
        });
  }
}
