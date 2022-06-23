import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/locale.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/core/service/cast_movies.service.dart';
import 'package:moviebox/core/service/collection.service.dart';
import 'package:moviebox/core/service/favorite.service.dart';
import 'package:moviebox/core/service/genre.service.dart';
import 'package:moviebox/core/service/movie.service.dart';
import 'package:moviebox/core/service/network.service.dart';
import 'package:moviebox/core/service/search.service.dart';
import 'package:moviebox/core/service/season.service.dart';
import 'package:moviebox/core/service/translation.service.dart';
import 'package:moviebox/core/service/tv_episode_watchlist.service.dart';
import 'package:moviebox/core/service/tv_shows.service.dart';
import 'package:moviebox/core/service/user.service.dart';
import 'package:moviebox/core/service/watchlist.service.dart';
import 'package:moviebox/shared/util/theme_switch.dart';
import 'package:moviebox/themes.dart';
import 'package:moviebox/ui/auth/login/login.controller.dart';
import 'package:moviebox/ui/auth/register/register.controller.dart';
import 'package:moviebox/ui/cast_details/cast_details.controller.dart';
import 'package:moviebox/ui/genre/results/movies_by_genre.controller.dart';
import 'package:moviebox/ui/genre/results/tv_shows_by_genre.controller.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';
import 'package:moviebox/ui/home/home_page.controller.dart';
import 'package:moviebox/ui/home/navigation/navigation.dart';
import 'package:moviebox/ui/movies_details/movies_details.controller.dart';
import 'package:moviebox/ui/plateforms/companies/company_result.controller.dart';
import 'package:moviebox/ui/plateforms/networks/network_result.controller.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_details.controller.dart';
import 'package:wiredash/wiredash.dart';

import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await setPreferredOrientations();
  await initDependencies();
  final TranslationService translationService = TranslationService();
  final AppTranslations translations =
  await translationService.getTranslations();
  return runZonedGuarded(() async {
    runApp(MyApp(translations: translations));
  }, (Object error, StackTrace stack) {});
}

Future<void> initDependencies() async {
  Get.put<UserService>(UserService(), permanent: true);
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<CastService>(CastService(), permanent: true);
  Get.put<CollectionService>(CollectionService(), permanent: true);
  Get.put<FavouriteService>(FavouriteService(), permanent: true);
  Get.put<GenreService>(GenreService(), permanent: true);
  Get.put<MoviesService>(MoviesService(), permanent: true);
  Get.put<ColorGenerator>(ColorGenerator(), permanent: true);

  Get.put<NetworkService>(NetworkService(), permanent: true);
  Get.put<SearchService>(SearchService(), permanent: true);
  Get.put<SeasonService>(SeasonService(), permanent: true);
  Get.put<TvWatchlistService>(TvWatchlistService(), permanent: true);
  Get.put<TvShowService>(TvShowService(), permanent: true);
  Get.put<WatchListService>(WatchListService(), permanent: true);
  Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  Get.lazyPut<RegisterController>(() => RegisterController(), fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  Get.lazyPut<CastDetailsController>(() => CastDetailsController(), fenix: true);

  Get.lazyPut<MoviesByGenreController>(() => MoviesByGenreController(), fenix: true);
  Get.lazyPut<TvShowsByGenreController>(() => TvShowsByGenreController(), fenix: true);
  Get.lazyPut<AllMoviesController>(() => AllMoviesController(), fenix: true);
  Get.lazyPut<AllTvShowsController>(() => AllTvShowsController(), fenix: true);
  Get.lazyPut<HomePageController>(() => HomePageController(), fenix: true);
  Get.lazyPut<MoviesDetailsController>(() => MoviesDetailsController(), fenix: true);
  Get.lazyPut<TvShowsDetailsController>(() => TvShowsDetailsController(), fenix: true);
  Get.lazyPut<CompanyResultController>(() => CompanyResultController(), fenix: true);
  Get.lazyPut<NetworkResultController>(() => NetworkResultController(), fenix: true);

}
Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // Prevent Landscape mode
    // DeviceOrientation.landscapeRight,
    // DeviceOrientation.landscapeLeft,
  ]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppTranslations translations;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final MyTheme myTheme = MyTheme();
   MyApp({Key? key, required this.translations}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Wiredash(
        projectId: 'movies-box-w8fewxn',
        secret: 'C70EUlrPDvbqIbQ1ar-RGkOSevQ-qypg',
        navigatorKey: _navigatorKey,
        options: WiredashOptionsData(
            locale: myTheme.currentLocale),
        theme: WiredashThemeData(
          brightness: Theme.of(context).brightness,
        ),
        child: Directionality(
          textDirection: myTheme.language == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: GetMaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
               primaryColorDark: Colors.black,
              primaryColorLight: Colors.white
               ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColorDark: Colors.white,
                primaryColorLight: Colors.black,

                scaffoldBackgroundColor: Colors.black
                ),
            themeMode: myTheme.currentMode(),
            translations: translations,
            locale: myTheme.currentLocale,
            getPages: AppRoutes.routes,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate
            ],
            home: NavigationView(),
          ),
        ));
  }


}