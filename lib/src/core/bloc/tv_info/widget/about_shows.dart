
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';
import 'package:moviebox/src/shared/widget/expandable.dart';

import '../../../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutShowWidget extends StatelessWidget {
  const AboutShowWidget({
    Key? key,
    required this.textColor,
    required this.info,
  }) : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: ExpandableGroup(
          isExpanded: true,
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: textColor != Colors.white ? Colors.black : Colors.white,
          ),
          collapsedIcon: Icon(
            Icons.arrow_drop_down,
            color: textColor != Colors.white ? Colors.black : Colors.white,
          ),
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "movie_info.about_tv".tr(),
              style: heading.copyWith(color: textColor),
            ),
          ),
          items: [
            if (info.created.isNotEmpty)
              ListTile(
                title: Text(
                  "movie_info.writers".tr(),
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
                    children: [
                      ...info.created
                          .map(
                            (genre) => TextSpan(text: "$genre, "),
                          )
                          .toList()
                    ],
                  ),
                ),
              ),
         
            ListTile(
                title: Text(
                  "movie_info.nb_seasons".tr(),
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.numberOfSeasons,
                  style: normalText.copyWith(color: textColor),
                )),
            ListTile(
                title: Text(
                  "movie_info.episode_runtime".tr(),
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.episoderuntime,
                  style: normalText.copyWith(color: textColor),
                )),
            if (info.formatedDate != "")
              ListTile(
                title: Text(
                  "movie_info.released_tv".tr(),
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
                    children: [
                      TextSpan(text: info.formatedDate),
                    ],
                  ),
                ),
              ),
            if (info.tagline != "")
              ListTile(
                title: Text(
                  "movie_info.tagline_tv".tr(),
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.tagline,
                  style: normalText.copyWith(color: textColor),
                ),
              )
          ],
        ),
      ),
    );
  }
}
