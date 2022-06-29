import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/shared/util/profile_list_items.dart';
import 'package:moviebox/ui/watchlist/movies/watchlist_items.dart';

import '../../../themes.dart';
import '../add_to_watchlist_fav.dart';

class WatchlistTab extends StatefulWidget {
  final ProfileItems type;

  const WatchlistTab({Key? key, required this.type}) : super(key: key);

  @override
  _WatchlistTabState createState() => _WatchlistTabState();
}

class _WatchlistTabState extends State<WatchlistTab> {
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => new AddToLWatchlistFav(
                      isMovie: true, action: ProfileItems.movies)));
            },
          )
        ],
        leadingWidth: 10,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                appBarItem(0, 'my_list.all'),
                SizedBox(
                  width: 10,
                ),
                appBarItem(1, 'my_list.finished'),
                SizedBox(
                  width: 10,
                ),
                appBarItem(2, 'my_list.not_started'),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            widget.type == ProfileItems.movies
                ? "my_list.movies".tr
                : "my_list.shows".tr,
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
          WatchlistItems(type: widget.type),
          WatchlistItems(type: widget.type, watched: true),
          WatchlistItems(type: widget.type, watched: false),
        ],
      ),
    );
  }

  Widget appBarItem(int index, String title) {
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
        borderRadius: BorderRadius.circular(16),
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
          title.tr,
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
