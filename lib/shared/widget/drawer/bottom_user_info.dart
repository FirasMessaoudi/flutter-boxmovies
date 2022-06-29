import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/core/service/auth.service.dart';
import 'package:moviebox/shared/util/constant.dart';

class BottomUserInfo extends StatelessWidget {
  AuthService authService = Get.find();
  final bool isCollapsed;
   BottomUserInfo({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Get.theme.primaryColorDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
        child: Row(
          children: [
            if( FirebaseAuth.instance.currentUser!=null)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL??defaultImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                       FirebaseAuth.instance.currentUser!=null?
                FirebaseAuth.instance.currentUser!.displayName??'':'login.login'.tr,
                        style: TextStyle(
                          color: Get.theme.primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                 /* Expanded(
                    child: Text(
                      'MEMBER',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),*/
                ],
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () async{
                    if(FirebaseAuth.instance.currentUser!=null) {
                      await authService.signOut();
                    }else{
                      Get.toNamed(AppRoutes.login);
                    }
                  },
                  icon:  Icon(
                    FirebaseAuth.instance.currentUser!=null?Icons.logout:Icons.login,
                    color: Get.theme.primaryColorDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          if(FirebaseAuth.instance.currentUser!=null)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL??defaultImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () async{
                if(FirebaseAuth.instance.currentUser!=null) {
                  await authService.signOut();
                }else{
                  Get.toNamed(AppRoutes.login);
                }
              },
              icon:  Icon(
                FirebaseAuth.instance.currentUser!=null?Icons.logout:Icons.login,
                color: Get.theme.primaryColorDark,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}