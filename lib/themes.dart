import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviebox/src/shared/util/config.dart';

// final Color scaffoldColor = Colors.black;
final Color titleColor = Color.fromRGBO(255, 66, 79, 1);
final redColor = Color.fromRGBO(255, 66, 79, 1);
final TextStyle normalText =
    GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, letterSpacing: 0.8));
    final TextStyle smalltext =
    GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12, letterSpacing: 0.5));
final TextStyle heading = GoogleFonts.poppins(
  textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
);

Color kAppPrimaryColor = Colors.grey.shade200;
Color kWhite = Colors.white;
Color kLightBlack = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;


IconData twitter = IconData(0xe900, fontFamily: "CustomIcons");
IconData facebook = IconData(0xe901, fontFamily: "CustomIcons");
IconData googlePlus =
IconData(0xe902, fontFamily: "CustomIcons");
IconData linkedin = IconData(0xe903, fontFamily: "CustomIcons");

const kSpacingUnit = 10;

final kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: kAppPrimaryColor,
    boxShadow: [
      BoxShadow(
        color: kWhite,
        offset: Offset(10, 10),
        blurRadius: 10,
      ),
      BoxShadow(
        color: kWhite,
        offset: Offset(-10, -10),
        blurRadius: 10,
      ),
    ]
);