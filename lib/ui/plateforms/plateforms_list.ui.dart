import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moviebox/core/model/network.model.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/shared/widget/appbar.dart';
import 'package:moviebox/shared/widget/responsive.dart';
import 'package:moviebox/ui/plateforms/companies/company_result.controller.dart';
import 'package:moviebox/ui/plateforms/networks/network_result.controller.dart';


import '../../themes.dart';

class PlateformsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final networks = NetworksList.fromJson(networklist).list;
    final companies = NetworksList.fromJson(companylist).list;

    return Scaffold(
      appBar: DefaultAppBar(title: 'Networks & Companies',),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    "networks.popular_network".tr,
                    style: heading.copyWith(
                      color: Theme.of(context).brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 28 / 16),
                  children: [
                    for (var i = 0; i < networks.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: NetworkTile(
                          network: networks[i],
                          isMovie: false,
                        ),
                      )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10),
                child: Text(
                  "networks.popular_studios".tr,
                  style: heading.copyWith(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 28 / 16),
                  children: [
                    for (int i = 0; i < companies.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: NetworkTile(
                            network: companies[i], isMovie: true),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkTile extends StatelessWidget {
  final Network network;
  final bool isMovie;

  NetworkTile({Key? key, required this.network, required this.isMovie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child:  Column(
        children: [
          Hero(
            tag: network.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: AssetImage('assets/img/' + network.image),
                fit: BoxFit.cover,
                height: Responsive.isDesktop(context) ? 200.0 : 100.0,
                width: Responsive.isDesktop(context) ? 250.0 : 100.0,
              ),
            ),
          )
        ],
      ),
      onTap: () {
        if (!isMovie) {
          NetworkResultController.instance.initSearch(network.id);
          Get.toNamed(AppRoutes.network, arguments: network.name);
        } else {
          CompanyResultController.instance.initSearch(network.id);
          Get.toNamed(AppRoutes.company, arguments: network.name);
        }
      },
    );
  }
}
