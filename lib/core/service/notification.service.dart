import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NotificationService {
  //Fixme should be refactored
  static void infoSnackbar(String title, String message) {
    snackbar(title, message, 'info', Color(0xFF5561b8), true);
  }

  static void successSnackbar(String title, String message) {
    snackbar(title, message, 'success', Color(0xFF3b7937), false);
  }

  static void warningSnackbar(String title, String message) {
    snackbar(title, message, 'warn', Color(0xFFab7647), false);
  }

  static void errorSnackbar(String title, String message) {
    snackbar(title, message, 'error', Color(0xFFb54f55), false);
  }

  static void snackbar(
      String title, String message, String severity, Color color, bool rotate) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: 4),
      borderRadius: 0.0,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(20.0),
      shouldIconPulse: false,
      backgroundColor: color.withOpacity(0.75),
      colorText: Colors.white,
      icon: Transform.rotate(
        angle: (rotate ? 180 : 0) * pi / 180,
        child: Lottie.asset('assets/img/lottie/$severity.json',
            repeat: true, reverse: false, animate: true, height: 48.0),
      ),
      snackPosition: SnackPosition.TOP,
    );
  }
}
