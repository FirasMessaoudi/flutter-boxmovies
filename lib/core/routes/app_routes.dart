import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/ui/auth/login/login.ui.dart';
import 'package:moviebox/ui/auth/register/register.ui.dart';
import 'package:moviebox/ui/cast_details/cast_details.ui.dart';
import 'package:moviebox/ui/genre/genre_list.ui.dart';
import 'package:moviebox/ui/genre/results/genre_result.ui.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.ui.dart';
import 'package:moviebox/ui/home/all_tv_show/all_shows.ui.dart';
import 'package:moviebox/ui/home/home_page.ui.dart';
import 'package:moviebox/ui/home/navigation/navigation.dart';
import 'package:moviebox/ui/movies_details/movies_details.ui.dart';
import 'package:moviebox/ui/plateforms/companies/company_result.ui.dart';
import 'package:moviebox/ui/plateforms/networks/network_result.ui.dart';
import 'package:moviebox/ui/profile/edit/edit_profile.dart';
import 'package:moviebox/ui/profile/info/profile_info.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_details.ui.dart';

class AppRoutes {


  AppRoutes._();
  static String genres = '/genre';
  static String genresResult = '/genre/results';
  static String plateforms ='/plateforms';
  static String company ='/plateforms/companies';
  static String network ='/plateforms/networks';
  static String home ='/home';
  static String profile = '/profile/info';
  static String login ='/auth/login';
  static String register = '/auth/register';
  static String navigation = '/home/navigation';
  static String allMovies='/home/all_movies';
  static String allTvShow='/home/all_tv_show';
  static String movieDetails= '/movies_details';
  static String tvShowDetails = '/tv_shows_details';
  static String castDetails ='/cast_details';
  static String settings ='/profile/edit';

  static final List<GetPage<Widget>> routes = <GetPage<Widget>>[
    GetPage<GenreListView>(
        name: genres,
        page: () => GenreListView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<GenreResultView>(
        name: genresResult,
        page: () => GenreResultView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<NetworkResultView>(
        name: network,
        page: () => NetworkResultView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<CompanyResultView>(
        name: company,
        page: () => CompanyResultView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<HomepageView>(
        name: home,
        page: () => HomepageView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<LoginView>(
        name: login,
        page: () => LoginView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<RegisterView>(
        name: register,
        page: () => RegisterView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<NavigationView>(
        name: navigation,
        page: () => NavigationView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),

    GetPage<AllMoviesView>(
        name: allMovies,
        page: () => AllMoviesView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<AllTvShowView>(
        name: allTvShow,
        page: () => AllTvShowView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),

    GetPage<MoviesDetailsView>(
        name: movieDetails,
        page: () => MoviesDetailsView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),

    GetPage<TvShowDetailsView>(
        name: tvShowDetails,
        page: () => TvShowDetailsView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),

    GetPage<CastDetailsView>(
        name: castDetails,
        page: () => CastDetailsView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<ProfileInfoView>(
        name: profile,
        page: () => ProfileInfoView(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),
    GetPage<EditProfile>(
        name: settings,
        page: () => EditProfile(),
        transition: Transition.upToDown,
        preventDuplicates: true,
        opaque: false,
        curve: Curves.fastLinearToSlowEaseIn),

];
}