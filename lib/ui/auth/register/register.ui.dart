import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/ui/auth/custom.dart';
import 'package:moviebox/ui/auth/login/login_with_socials.dart';
import 'package:moviebox/ui/auth/register/register.controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({Key? key}) : super(key: key);

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
                          txt: "login.register".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      customText(
                          txt: "Please Sign Up to continue using our app.",
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
                          txt: "or continue with email",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(Lone: "login.name".tr, Htwo: "login.name".tr,onChanged: (dynamic value){
                        controller.name = value;
                      }),
                      const SizedBox(height: 20),
                      CustomTextField(Lone: "edit_profile.email".tr, Htwo: "edit_profile.email".tr,onChanged: (dynamic value){
                        controller.email = value;
                      }),
                      const SizedBox(height: 20),
                      CustomTextField(obscure:true,Lone: "Password", Htwo: "Password",onChanged: (dynamic value){
                        controller.password = value;
                      }),
                      const SizedBox(height: 40),
                      InkWell(
                        child: SignUpContainer(st: 'login.register'.tr),
                        onTap: () async{
                          await controller.handleRegister();
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        child: RichText(
                          text: RichTextSpan(
                              one: "login.have_account".tr, two: "login.login".tr),
                        ),
                        onTap: () {
                         Get.toNamed(AppRoutes.login);
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
