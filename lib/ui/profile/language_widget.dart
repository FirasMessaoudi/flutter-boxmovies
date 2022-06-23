import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/ui/home/home_page.controller.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';

class LanguageWidget extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return dropdown();
  }

  Widget dropdown() {
    return Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: DropdownButton<String>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String? value) async {
              if (value == 'English') {
                Get.updateLocale(Locale('en', 'US'));
                controller.switchLanguage('en');
              } else if (value == 'French') {
                controller.switchLanguage('fr');
                Get.updateLocale(Locale('fr', 'FR'));
              } else if (value == 'Arabic') {
                controller.switchLanguage('ar');
                Get.updateLocale(Locale('ar', 'SA'));
              } else if (value == 'Spanish') {
                controller.switchLanguage('es');
                Get.updateLocale(Locale('es', 'ES'));
              } else if (value == 'Italian') {
                controller.switchLanguage('it');
                Get.updateLocale(Locale('it', 'IT'));
              }
              HomePageController.instance.initHomePage(true);
            },
            items: <String>['English', 'French', 'Arabic', 'Spanish', 'Italian']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
              );
            }).toList()));
  }
}
