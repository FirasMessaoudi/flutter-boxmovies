import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moviebox/core/model/user.model.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/core/service/user.service.dart';
import 'package:moviebox/core/service/watchlist.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';
import 'package:moviebox/shared/util/theme_switch.dart';
import 'package:moviebox/ui/home/home_page.controller.dart';

class ProfileController extends GenericController with GetSingleTickerProviderStateMixin{
  static ProfileController get instance => Get.find();
  final MyTheme myTheme = MyTheme();
  final UserService userService = Get.find();
  final AuthService authService = Get.find();
  final WatchListService watchListRepo = Get.find();
  Rx<MyUser> user = MyUser().obs;
  int nbWatchedMovie = 0;
  int nbWatchedEpisodes = 0;
  int nbCountMovies = 0;
  int nbCountTv = 0;
  int nbCountCollections = 0;
  int nbCountFav = 0;
  int nbMinutesWatched = 0;
  String period = '';
   RxBool isLoading = true.obs;
  bool isSwitched = true;
  final picker = ImagePicker();
  bool isSelected = false;
  bool isSelectedCover = false;
  late File imageFile;
  late File coverFile;
  String name = '';
  String description = '';
  TextEditingController textFieldController = new TextEditingController();
  TextEditingController textFieldControllerDescription =
  new TextEditingController();
  String birthdate = '';
  final f = new DateFormat('dd/MM/yyyy');
  String selectedCountry = '';
  String? selectedLanguage;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  initialization() async{
    isLoading(true);
    user.value = (await userService.findUserData())!;
    nbWatchedMovie = await watchListRepo.getNbWatchedMovies();
    nbWatchedEpisodes= await watchListRepo.getNbWatchedEpisode();

    nbCountMovies = await watchListRepo.getMovieListCount();
    nbCountTv  = await watchListRepo.getTvListCount();
    nbCountCollections = await watchListRepo.getCollectionCount();
    nbCountFav = await watchListRepo.getFavCount();
    nbMinutesWatched = await  watchListRepo.getNbMinutesOfEpisodes();
      period = timeConvert(nbMinutesWatched);
      isLoading(false);
  }

  logout() async {
    await authService.signOut();
    HomePageController.instance.tabIndex.value = 0;
    HomePageController.instance.onInit();
  }
  String timeConvert(int time) {
    String t = "";

    double j = time / (24 * 60);
    double h = (time % (24 * 60)) / 60;
    double m = (time % (24 * 60)) % 60;

    t = j.toInt().toString() +
        "d " +
        h.toInt().toString() +
        "h " +
        m.toInt().toString() +
        "m";
    return t;
  }

  updateUser(MyUser user) async{
    await userService.updateUser(user);
  }

  void switchTheme() {
    myTheme.switchTheme();
  }

  void switchLanguage(String languageCode) {
    myTheme.switchLanguage(languageCode);
  }
}