import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/ui/auth/custom.dart';
import 'package:moviebox/ui/auth/login/login.controller.dart';
import 'package:moviebox/ui/auth/login/login_with_socials.dart';


class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Center(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      customText(
                          txt: "Login Now",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      customText(
                          txt: "Please login to continue using our app.",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                      const SizedBox(
                        height: 60,
                      ),
                      customText(
                          txt: "Enter via social networks",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      LoginWithSocials(),
                      const SizedBox(
                        height: 40,
                      ),
                      customText(
                          txt: "or login with email",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(Lone: "edit_profile.email".tr, Htwo: "edit_profile.email".tr,onChanged: (dynamic value){
                        controller.email = value;
                      }),
                      const SizedBox(height: 20),
                      CustomTextField(obscure:true,Lone: "login.password".tr, Htwo: "login.password".tr,onChanged: (dynamic value){
                        controller.password = value;
                      }),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Spacer(),
                           TextButton(
                            onPressed: null,
                            child: Text(
                              "login.forgot_password".tr,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                      InkWell(
                        child: SignUpContainer(st: 'login.login'.tr),
                        onTap: () async{
                         await controller.login();
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        child: RichText(
                          text: RichTextSpan(
                              one: "login.no_account".tr, two: "login.register".tr),
                        ),
                        onTap: () {
                        Get.toNamed(AppRoutes.register);
                        },
                      ),
                      //Text("data"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



}
