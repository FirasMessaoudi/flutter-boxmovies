import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/shared/util/fav_type.dart';
import 'package:moviebox/shared/util/profile_list_items.dart';
import 'package:moviebox/ui/cast/add_cast_to_fav.dart';
import 'package:moviebox/ui/favorite/favorites_items.dart';
import 'package:moviebox/ui/watchlist/add_to_watchlist_fav.dart';
import '../../themes.dart';

class FavoritesTab extends StatefulWidget {
  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  int currentPage = 0;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(onPressed: (){
            switch(currentPage){
              case 0:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                    new AddToLWatchlistFav(isMovie: true, action: ProfileItems.fav)));
                break;
              case 1:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                    new AddToLWatchlistFav(isMovie: false, action: ProfileItems.fav)));
                break;
              case 2:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                    new AddToLWatchlistFav(isMovie: false, action: ProfileItems.fav)));
                break;
              case 3:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                    new AddCastToFav()));
                break;
              default:break;
            }
          }, icon: Icon(Icons.add))
        ],
        leadingWidth: 10,
        brightness: Brightness.dark,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                tabPage(0, 'my_list.movies'.tr),
                SizedBox(
                  width: 10,
                ),
                tabPage(1, 'my_list.shows'.tr),
                SizedBox(
                  width: 10,
                ),
                tabPage(2, 'my_list.episodes'.tr),
                SizedBox(
                  width: 10,
                ),
                tabPage(3, 'my_list.actors'.tr),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'my_list.my_favorites'.tr,
            style: heading.copyWith(
              //color: redColor,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          FavoritesItems(type: FavType.movie),
          FavoritesItems(type: FavType.tv),
          FavoritesItems(type: FavType.episode),
          FavoritesItems(type: FavType.person),
        ],
      ),
    );
  }

  Widget tabPage(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          currentPage = index;
          controller.animateToPage(index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutQuart);
        });
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        decoration: BoxDecoration(
            color: currentPage == index ? redColor : Colors.transparent,
            border: Border.all(
              width: 1.5,
              color: currentPage == index ? redColor : Colors.white,
            ),
            borderRadius: BorderRadius.circular(16)),
        child: Text(
          title,
          style: normalText.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: currentPage == index ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
