
import 'package:flutter/material.dart';
import 'package:moviebox/src/screens/collection/add_to_empty_collection.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../themes.dart';

class EmptyCollections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: redColor,
                  //fixedSize: Size(160, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18.0),
                      side: BorderSide(
                          color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                          width: 2.0))),
              child: Text('my_list.btn_empty_collection'.tr()),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => new AddToEmptyCollection(
                       )));
                //refresh();
                // Navigator.of(context).pop();

              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'my_list.empty_collection_title'.tr(),
              style: heading.copyWith(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'my_list.empty_collection_message'.tr(),
              textAlign: TextAlign.center,
              style: normalText.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}
