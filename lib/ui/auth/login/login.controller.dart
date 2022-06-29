import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/core/service/notification.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';

class LoginController extends GenericController {
  final AuthService authService = Get.find();
  String email = '';
  String password = '';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  login() async{
    if(email=='' || password==''){
      NotificationService.errorSnackbar(
          'Error', 'Please enter your credentials !');
      return ;
    }
    UserCredential? user = await authService.login(email, password);
    if(user!=null){
      ProfileController.instance.initialization();
      Get.toNamed(AppRoutes.profile);
    }else {
      //show error message
      NotificationService.errorSnackbar(
          'Error', 'There is no user with these credentials !');
    }

  }

  googleLogin() async {
   await  authService.googleLogin();
  }

  googleLoginWithCredentials(bool link, AuthCredential? credential) async {
    await authService.googleLogin(link,credential);
  }

  Future<Resource?> signInWithTwitter() async {
     final response =  await authService.signInWithTwitter();
     return response;
  }

  Future<Resource?>  signInWithFacebook() async{
    final response = await authService.signInWithFacebook();
    return response;
  }
}