import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/core/service/notification.service.dart';
import 'package:moviebox/shared/util/login_type.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/ui/auth/login/login.controller.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';

class LoginWithSocials extends GetView<LoginController> {

  const LoginWithSocials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: MaterialButton(
            onPressed: () async {
              loginWithProvider(LoginType.facebook, context);
            },
            color: Color(0xFF3b5998),
            textColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.facebookF,
              size: 22,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
        // SizedBox(width: 10,),
        Container(
          child: MaterialButton(
            onPressed: () async {
              loginWithProvider(LoginType.google, context);
            },
            color: Color(0xFFEA4335),
            textColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.google,
              size: 22,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
        Container(
          child: MaterialButton(
            onPressed: () async {
              loginWithProvider(LoginType.twitter, context);
            },
            color: Color.fromRGBO(29, 161, 242, 1),
            textColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.twitter,
              size: 22,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }

  void loginWithProvider(LoginType loginType, BuildContext context) async {
    switch (loginType) {
      case LoginType.facebook:
        {
          try {
            showLoaderDialog(context);
            final Resource? response = await controller.signInWithFacebook();
            print(response?.status);
            if (response?.status == Status.Success) {
              ProfileController.instance.initialization();
              Get.toNamed(AppRoutes.profile);

            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              Get.back();
              showMessage(e, context);
            }
          }
        }
        break;
      case LoginType.google:
        {
          showLoaderDialog(context);
          await controller.googleLogin();
          ProfileController.instance.initialization();
          Get.toNamed(AppRoutes.profile);


        }
        break;
      case LoginType.twitter:
        {
          showLoaderDialog(context);
          try {
            final Resource? response = await controller.signInWithTwitter();
            if (response?.status == Status.Success) {
             // go to home
              ProfileController.instance.initialization();
              Get.toNamed(AppRoutes.profile);


            } else {
              Navigator.of(context).pop(context);
              NotificationService.errorSnackbar(
                  'Error', 'Error while login with twitter !');
            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              Navigator.of(context).pop(context);
              showMessage(e, context);
            }
          }
        }
    }
  }

  void showMessage(FirebaseAuthException e, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message!),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Get.back();
                  print(e.code);
                  if (e.code == 'account-exists-with-different-credential') {
                    List<String> emailList = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(e.email!);
                    if (emailList.first == "google.com") {
                      await controller.googleLoginWithCredentials(true, e.credential);
                       //go to home
                    }
                  }
                },
              )
            ],
          );
        });
  }
}
