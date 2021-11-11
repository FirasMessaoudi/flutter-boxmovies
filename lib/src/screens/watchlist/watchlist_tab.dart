import 'package:flutter/material.dart';
import 'package:moviebox/src/screens/watchlist/watchlist_items.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';

import '../../../themes.dart';
import 'package:easy_localization/easy_localization.dart';


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
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
          Navigator.pop(context);
        },),
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
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 0;
                      controller.animateToPage(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuart);
                    });
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    decoration: BoxDecoration(
                        color: currentPage == 0
                            ? redColor
                            : Colors.transparent,
                        border: Border.all(
                          width: 1.5,
                          color: currentPage == 0
                              ? redColor
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      "my_list.all".tr(),
                      style: normalText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: currentPage == 0 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {
                    setState(() {
                      currentPage = 1;
                      controller.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuart);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    decoration: BoxDecoration(
                        color: currentPage == 1
                            ? redColor
                            : Colors.transparent,
                        border: Border.all(
                          width: 1.5,
                          color: currentPage == 1
                              ? redColor
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      "my_list.finished".tr(),
                      style: normalText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: currentPage == 1 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {
                    setState(() {
                      controller.animateToPage(2,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuart);

                      currentPage = 2;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    decoration: BoxDecoration(
                        color: currentPage == 2
                            ? redColor
                            : Colors.transparent,
                        border: Border.all(
                          width: 1.5,
                          color: currentPage == 2
                              ? redColor
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      "my_list.not_started".tr(),
                      style: normalText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: currentPage == 2 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            widget.type==ProfileItems.movies?"my_list.movies".tr():"my_list.shows".tr(),
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
          WatchlistItems(type:widget.type),
          WatchlistItems(type: widget.type, watched:true),
          WatchlistItems(type: widget.type, watched:false),
        ],
      ),
    );
  }
}