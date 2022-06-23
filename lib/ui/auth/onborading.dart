
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/ui/auth/custom.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Column(
              children: [
                const Image(image: AssetImage("assets/img/img2.png")),
                const SizedBox(height: 48),
                customText(
                    txt: "Thank You",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                customText(
                    txt: "Now, welcome to our beautiful app!",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    )),
                const SizedBox(height: 60),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  child: InkWell(
                    child: SignUpContainer(st: "Let's Go"),
                    onTap: () {
                     Get.toNamed(AppRoutes.login);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}