import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moviebox/shared/widget/drawer.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/ui/auth/welcome_screen.dart';
import 'package:moviebox/ui/genre/genre_list.ui.dart';
import 'package:moviebox/ui/home/home_page.controller.dart';
import 'package:moviebox/ui/plateforms/plateforms_list.ui.dart';

import '../home_page.ui.dart';

class NavigationView extends GetView<HomePageController> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      builder: (HomePageController controller) {
        return Scaffold(
          body: SafeArea(
            child: Obx(
                  () => IndexedStack(
                index: controller.tabIndex.value,
                children: <Widget>[
                   HomepageView(),
                   GenreListView(),
                   PlateformsListView(),
                   WelcomeScreen(),
                ],
              ),
            ),
          ),
          bottomNavigationBar:!Responsive.isDesktop(context)? Obx(
                () => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                ),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12.0,
                unselectedFontSize: 12.0,
                onTap: controller.changeTabIndex,
                currentIndex: controller.tabIndex.value,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: const Icon(FontAwesomeIcons.home,size: 18,),
                    label: 'home.home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(FontAwesomeIcons.search,size: 18),
                    label: 'home.discover'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(FontAwesomeIcons.tv,size: 18),
                    label: 'home.networks'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon:  Icon(controller.isLoggedIn()?FontAwesomeIcons.user:FontAwesomeIcons.signInAlt,size: 18),
                    label:controller.isLoggedIn()?'home.profile'.tr:'login.login'.tr,
                  )
                ],
                selectedItemColor: Get.isDarkMode
                    ? Colors.white
                    : Colors.black,
                unselectedItemColor: Colors.grey,
              ),
            ),
          ):null,

        );
      },
    );
  }

 
}
