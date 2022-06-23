import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:moviebox/core/model/movie_info.model.dart';
import 'package:moviebox/shared/widget/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar(
      {Key? key,
        this.leadingIcon=Icons.arrow_back_ios,
        this.leadingBtnAction,
        this.actionIcon,
        this.secondIcon,
        this.actionBtnAction,
        this.secondBtnAction,
        this.bottom,
        this.bellWidget,
        this.title = ''})
      : super(key: key);

  final IconData? leadingIcon;
  final Function? leadingBtnAction;
  final IconData? actionIcon;
  final IconData? secondIcon;
  final Widget? bellWidget;
  final Function? actionBtnAction;
  final Function? secondBtnAction;
  final String? title;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      shadowColor: Color(0x7EDEDEDE),
      elevation: 1.0,
      toolbarHeight: 90.0,
      backgroundColor: Colors.transparent,
      leading: leadingIcon != null
          ? IconButton(
        icon: Icon(
          leadingIcon,
          color: Get.theme.primaryColorDark,
          size: 20,
        ),
        onPressed: () {
          Get.back();
        },
      )
          : SizedBox(
        width: 40.0,
      ),
      title: Center(
        child: Text(
          title!,
          style: Get.theme.textTheme.bodyText1!.copyWith(
            color: Get.theme.primaryColorDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      actions: <Widget>[
        actionIcon != null
            ? Container(
          transform: Matrix4.translationValues(
              Get.locale!.languageCode == 'ar' ? 5 : -5, 0, 0),
          child: IconButton(
            icon: Icon(
              actionIcon,
              color: Get.theme.primaryColorDark,
              size: 20,
            ),
            onPressed: () {
              if (actionBtnAction != null) actionBtnAction!();
              // Get.toNamed(AppRoutes.notifications);
            },
          ),
        )
            : bellWidget != null
            ? Container(
            transform: Matrix4.translationValues(
                Get.locale!.languageCode == 'ar' ? 5 : -5, 0, 0),
            child: bellWidget!)
            : SizedBox(
          width: 40.0,
        ),
        secondIcon != null
            ? Container(
          transform: Matrix4.translationValues(
              Get.locale!.languageCode == 'ar' ? 5 : -5, 0, 0),
          child: IconButton(
            icon: Icon(
              secondIcon,
              color: Get.theme.primaryColorDark,
              size: 20,
            ),
            onPressed: () {
              if (secondBtnAction != null) secondBtnAction!();
              // Get.toNamed(AppRoutes.notifications);
            },
          ),
        )
            : Container()
      ],
    );
  }

  @override
  Size get preferredSize => Size(Get.size.width, bottom != null ? 142.0 : 60.0);
}

