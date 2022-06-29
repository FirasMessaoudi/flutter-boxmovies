import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawerHeader extends StatelessWidget {
  final bool isCollapsed;

  const CustomDrawerHeader({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 30),
          if (isCollapsed) const SizedBox(width: 10),
          if (isCollapsed)
             Expanded(
              flex: 3,
              child: Text(
                'Movies Box',
                style: TextStyle(
                  color: Get.theme.primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
              ),
            ),
          if (isCollapsed) const Spacer(),
        ],
      ),
    );
  }
}