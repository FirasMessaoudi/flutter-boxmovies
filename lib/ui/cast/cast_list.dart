import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/ui/cast_details/cast_details.controller.dart';
import '../../themes.dart';
import '../../core/model/movie_info.model.dart';

class CastList extends StatelessWidget {
  const CastList({
    Key? key,
    required this.castList,
    required this.textColor,
  }) : super(key: key);

  final List<CastInfo> castList;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 10),
          for (var i = 0; i < castList.length; i++)
            if (castList[i].image != "")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    // go to cast details
                    // init cast
                    Get.toNamed(AppRoutes.castDetails,arguments: {'title':castList[i].name,'image':castList[i].image});
                    CastDetailsController.instance.findCast(castList[i].id!);

                  },
                  child: Tooltip(
                    message: "${castList[i].name} as ${castList[i].character}",
                    child: Container(
                      width: 130,
                      constraints: BoxConstraints(minHeight: 290),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 130,
                            color: Colors.black,
                            child: CachedNetworkImage(
                              imageUrl: castList[i].image??'',
                              fit: BoxFit.cover,
                              height: 200,
                              width: 130,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 130,
                            child: Text(
                              castList[i].name??'',
                              maxLines: 2,
                              style: normalText.copyWith(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 130,
                            child: Text(
                              castList[i].character??'',
                              maxLines: 2,
                              style: normalText.copyWith(
                                  color: textColor.withOpacity(.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
