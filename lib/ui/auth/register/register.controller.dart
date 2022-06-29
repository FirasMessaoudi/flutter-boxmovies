import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/core/service/notification.service.dart';
import 'package:moviebox/core/service/user.service.dart';
import 'package:moviebox/shared/controller/generic.controller.dart';
import 'package:moviebox/shared/util/validators.dart';

class RegisterController extends GenericController{
  String email = '';
  String password = '';
  String name = '';
  final AuthService authService = Get.find();
  final UserService userService = Get.find();

  handleRegister()async{
    if(!isEmail(email) && password.length < 6){
      // error message
      NotificationService.errorSnackbar(
          'Error', 'Invalid email or name !');
      return;
    }
    UserCredential? user = await authService.signup(email, password);
    if (user != null) {
      await userService.saveUser(name, email);
      //success message
      NotificationService.errorSnackbar(
          'Success', 'User saved successfully !');
      Get.toNamed(AppRoutes.login);
    }else{
      // error message
      NotificationService.errorSnackbar(
          'Error', 'Error while signing Up !');
    }
  }
}