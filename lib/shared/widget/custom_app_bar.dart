import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/themes.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.ui.dart';
import 'package:moviebox/ui/home/all_tv_show/all_shows.ui.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';
import 'package:moviebox/ui/home/home_page.controller.dart';
import 'package:moviebox/ui/plateforms/plateforms_list.ui.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';
import 'package:moviebox/ui/profile/info/profile_info.dart';
import 'package:moviebox/ui/search/search_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

class CustomAppBar extends GetView<HomePageController> {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      color:
      Colors.black.withOpacity((controller.offset.value / 450).clamp(0, 1).toDouble()),
      child: Responsive(
        mobile: CustomAppBarMobile(),
        desktop: CustomAppBarDesktop(),
        tablet: new Container(),
      ),
    ));
  }
}

class CustomAppBarMobile extends StatelessWidget {

  const CustomAppBarMobile({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                tooltip: 'Open menu',
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              );
            }
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

class CustomAppBarDesktop extends StatelessWidget {
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
                _AppBarButton(title: 'home.home'.tr, route: 'home'),
                _AppBarButton(
                  title: 'home.series'.tr,
                  route: 'tv',
                ),
                _AppBarButton(
                  title: 'home.movies'.tr,
                  route: 'movie',
                ),
                _AppBarButton(title: 'home.genres'.tr, route: 'genre'),
                _AppBarButton(title: 'home.networks'.tr, route: 'network'),
                
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
               

                DropdownScreen(),
                FirebaseAuth.instance.currentUser != null
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.person),
                        iconSize: 28.0,
                        color: Colors.white,
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileInfoView()))
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
         Get.toNamed(AppRoutes.genres);
        } else if (route == 'network') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PlateformsListView()));
        } else if (route == 'movie') {
          Get.toNamed(AppRoutes.allMovies);
          AllMoviesController.instance.onInit();
        } else if (route == 'tv') {
          Get.toNamed(AppRoutes.allTvShow);
          AllTvShowsController.instance.onInit();
        } else if (route == 'list') {
          if(FirebaseAuth.instance.currentUser!=null)
            ProfileController.instance.initialization();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfileInfoView()));
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
    
      onPressed: () => {
      Get.toNamed(AppRoutes.login)
    },
      style: ElevatedButton.styleFrom(primary: redColor),
      // icon: const Icon(Icons.play_arrow, size: 30.0, color: Colors.black),
      child: Text(
        'login.login'.tr,
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
                 Get.updateLocale(Locale('en', 'US'));
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('language', 'en-US');
                });
              } else if (value == 'French') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'fr-FR');
               Get.updateLocale(Locale('fr', 'FR'));
              } else if (value == 'Arabic') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'ar-SA');
               Get.updateLocale(Locale('ar', 'SA'));
              } else if (value == 'Spanish') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'es-ES');
               Get.updateLocale(Locale('es', 'ES'));
              } else if (value == 'Italian') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', 'it-IT');
               Get.updateLocale(Locale('it', 'IT'));
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
