import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/screens/watchlist/tv/watchlist_tv_items.dart';
import '../../../../themes.dart';

class WatchListTvTab extends StatefulWidget {
  const WatchListTvTab({Key? key}) : super(key: key);

  @override
  _WatchListTvTabState createState() => _WatchListTvTabState();
}

class _WatchListTvTabState extends State<WatchListTvTab> {
  String sortBy = '0';

  @override
  void initState() {
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
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: false,
                  context: context,
                  builder: (context) {
                    return ListView(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 6),
                              Center(

                              child:Text(
                                'filter.sort_by'.tr(),
                                style: heading.copyWith(
                                  fontSize: 18,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              SizedBox(height: 8),
                              CustomRadioButton(
                                horizontal: true,
                                defaultSelected: this.sortBy,
                                unSelectedColor: Colors.white,
                                buttonLables: [
                                  'filter.all'.tr(),
                                  'filter.finished'.tr(),
                                  'filter.watching'.tr(),
                                  'filter.up_to_date'.tr(),
                                  'filter.not_started'.tr()
                                ],
                                buttonValues: ['0', '1', '2', '3', '4'],
                                radioButtonValue: (value) {
                                  setState(() {
                                    this.sortBy = value.toString();
                                    //Navigator.pop(context);
                                  });
                                },
                                width: 120,
                                selectedColor: redColor,
                                padding: 5,
                                spacing: 0.0,
                                enableShape: true,
                              ),
                            ])
                      ],
                    );
                  });
            },
            icon: Icon(Icons.sort),
          )
        ],
        leadingWidth: 10,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "my_list.shows".tr(),
            style: heading.copyWith(
              //color: redColor,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: WatchlistTvItems(sortBy: sortBy),
    );
  }
}
