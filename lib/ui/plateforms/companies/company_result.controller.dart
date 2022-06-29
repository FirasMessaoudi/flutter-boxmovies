import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/streams/company_stream.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';

class CompanyResultController extends GenericController with  GetSingleTickerProviderStateMixin{
  static CompanyResultController get instance => Get.find();

  late CompanyStream repo;
  late String query;
  late ScrollController scrollController;
  late String title = Get.arguments;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  initSearch(String query){
    this.query = query;
    repo = new CompanyStream();
    scrollController = new ScrollController();
    repo.addData(this.query);
    scrollController.addListener(_scrollListener);

  }
  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(query);
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    repo.dispose();

    super.dispose();
  }
}