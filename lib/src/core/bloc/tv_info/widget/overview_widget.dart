import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';
import 'package:readmore/readmore.dart';

import '../../../../../themes.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({
    Key? key,
    required this.textColor,
    required this.info,
  }) : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("movie_info.overview".tr(),
                style: heading.copyWith(color: textColor)),
            SizedBox(height: 10),
            ReadMoreText(
              info.overview,
              trimLines: 6,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'movie_info.show_more'.tr(),
              trimExpandedText: 'movie_info.show_less'.tr(),
              style: normalText.copyWith(
                  fontWeight: FontWeight.w500, color: textColor),
              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
