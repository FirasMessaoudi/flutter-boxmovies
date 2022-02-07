import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/responsive/app_bar_cubit.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/screens/auth/welcome_screen.dart';
import 'package:moviebox/src/screens/genre/genre_page.dart';
import 'package:moviebox/src/screens/network/networks.dart';
import 'package:moviebox/src/shared/widget/drawer.dart';

import 'home_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _currentIndex = 0;
  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseAuth.authStateChanges().listen((event) {
      print(event?.uid);
      if (mounted)
        setState(() {
          isLoggedIn = event?.uid != null;
          print(isLoggedIn);
        });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> _childrenLoggedIn = [
      Homepage(scaffoldKey: _scaffoldKey),
      GenrePage(),
      Networks(),
      WelcomeScreen()
    ];

    Map<String, IconData> _iconsLoggedIn = {
      'home.home'.tr(): Icons.home,
      'home.discover'.tr(): Icons.search,
      'home.networks'.tr(): Icons.queue_play_next,
      if (!isLoggedIn) 'login.login'.tr(): Icons.login,
      if (isLoggedIn) 'home.profile'.tr(): Icons.person,
    };

    return Scaffold(
      body: BlocProvider<AppBarCubit>(
        create: (_) => AppBarCubit(),
        child: _childrenLoggedIn[_currentIndex],
      ),
      bottomNavigationBar: !Responsive.isDesktop(context)
          ? BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.black,
        items: _iconsLoggedIn
            .map((title, icon) => MapEntry(
            title,
            BottomNavigationBarItem(
              icon: Icon(icon, size: 30.0),
              label: title,
            )))
            .values
            .toList(),
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        selectedFontSize: 11.0,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 11.0,
        onTap: (index) => setState(() => _currentIndex = index),
      )
          : null,
      drawer: Drawer(child: new DrawerUi()),
      key: _scaffoldKey,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
