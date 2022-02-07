import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/screens/auth/login_page.dart';
import 'package:moviebox/src/screens/genre/genre_page.dart';
import 'package:moviebox/src/screens/home/all_movies.dart';
import 'package:moviebox/src/screens/home/all_shows.dart';
import 'package:moviebox/src/screens/network/networks.dart';
import 'package:moviebox/src/screens/profile/profile_info.dart';
import 'package:moviebox/src/screens/search/search_delegate.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    this.scrollOffset = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      color:
      Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: Responsive(
        mobile: _CustomAppBarMobile(scaffoldKey: this.scaffoldKey),
        desktop: _CustomAppBarDesktop(),
        tablet: new Container(),
      ),
    );
  }
}

class _CustomAppBarMobile extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _CustomAppBarMobile({Key? key, required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          new GestureDetector(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: IconButton(
              tooltip: 'Open menu',
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/img/logo5.png',
                  fit: BoxFit.cover,
                )
                // _AppBarButton(
                //   title: 'TV Shows',
                //   route: 'tv',
                // ),
                // _AppBarButton(
                //   title: 'Movies',
                //   route: 'movie',
                // ),
                // _AppBarButton(
                //   title: 'My List',
                //   route: 'list',
                // ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search_sharp,
              color: Colors.white, // Here
            ),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
    );
  }
}

class _CustomAppBarDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.asset('img/logo5.png'),
          const SizedBox(width: 12.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppBarButton(title: 'Home', route: 'home'),
                _AppBarButton(
                  title: 'home.series'.tr(),
                  route: 'tv',
                ),
                _AppBarButton(
                  title: 'home.movies'.tr(),
                  route: 'movie',
                ),
                _AppBarButton(title: 'home.genres'.tr(), route: 'genre'),
                _AppBarButton(title: 'home.networks'.tr(), route: 'network'),
                // _AppBarButton(title: 'My List', route: 'list'),

                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (conetex) => Networks()))
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.search),
                  iconSize: 28.0,
                  color: Colors.white,
                  onPressed: () =>
                  {showSearch(context: context, delegate: DataSearch())},
                ),
                // _AppBarButton(
                //   title: 'Feedbacks',
                //   route: 'feedback',
                //   // Wiredash.of(context)!.show()
                // ),
                // _AppBarButton(
                //   title: 'DVD',
                //   onTap: () => print('DVD'),
                // ),

                DropdownScreen(),
                FirebaseAuth.instance.currentUser != null
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.person),
                        iconSize: 28.0,
                        color: Colors.white,
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileAppBar()))
                        },
                      )
                    : SignInButton(),
                // IconButton(
                //   padding: EdgeInsets.zero,
                //   icon: Icon(Icons.notifications),
                //   iconSize: 28.0,
                //   color: Colors.white,
                //   onPressed: () => print('Notifications'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final String title;
  final String route;

  const _AppBarButton({
    Key? key,
    required this.title,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route == 'feedback') {
          Wiredash.of(context)!.show();
        } else if (route == 'genre') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GenrePage()));
        } else if (route == 'network') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Networks()));
        } else if (route == 'movie') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Movies()));
        } else if (route == 'tv') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TvShows()));
        } else if (route == 'list') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfileAppBar()));
        }
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // padding: !Responsive.isDesktop(context)
      //     ? const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0)
      //     : const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
      onPressed: () => {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()))
      },
      style: ElevatedButton.styleFrom(primary: redColor),
      // icon: const Icon(Icons.play_arrow, size: 30.0, color: Colors.black),
      child: Text(
        'login.login'.tr(),
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DropdownScreen extends StatefulWidget {
  State createState() => DropdownScreenState();
}

class DropdownScreenState extends State<DropdownScreen> {
  late String selectedLanguage = 'English';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLanguageLabel()
        .then((value) => {print(value), selectedLanguage = value!});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            //color: Colors.transparent,
            border: Border.all()),
        child: DropdownButton<String>(
          value: selectedLanguage,
          icon: Icon(Icons.language),
          underline: Container(
            height: 2,
            color: Colors.transparent,
          ),
          onChanged: (String? value) {
            setState(() async {
              selectedLanguage = value!;
              if (value == 'English') {
                this.setState(() async {
                  context.setLocale(Locale('en', 'US'));
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('language', 'en-US');
                });
              } else if (value == 'French') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'fr-FR');
                context.setLocale(Locale('fr', 'FR'));
              } else if (value == 'Arabic') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'ar-SA');
                context.setLocale(Locale('ar', 'SA'));
              } else if (value == 'Spanish') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'es-ES');
                context.setLocale(Locale('es', 'ES'));
              } else if (value == 'Italian') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'it-IT');
                context.setLocale(Locale('it', 'IT'));
              }
            });
          },
          items: <String>['English', 'French', 'Arabic', 'Spanish', 'Italian']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    value,
                    // style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
  }
}
