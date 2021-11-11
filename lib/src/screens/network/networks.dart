import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/model/network.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/screens/network/company_info.dart';
import 'package:moviebox/src/screens/network/network_info.dart';
import 'package:moviebox/src/shared/util/config.dart';
import 'package:moviebox/src/shared/util/scroll_behaviour.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../themes.dart';

class Networks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final networks = NetworksList.fromJson(networklist).list;
    final companies = NetworksList.fromJson(companylist).list;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            // backgroundColor: scaffoldColor,
            body: SafeArea(
              child: Container(
                // color: scaffoldColor,
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 30,
                    ),
              
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'Back',
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                               icon: Icon(Icons.arrow_back_sharp)),
                            Text(
                              "networks.popular_network".tr(),
                              style: heading.copyWith(
                                color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                        "networks.popular_studios".tr(),
                        style: heading.copyWith(
                          color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
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
                    // BlocProvider(
                    //   create: (context) =>
                    //       UpcomingMoviesBloc()..add(LoadUpcomingMovies()),
                    //   child: UpcomingMoviesResults(),
                    // )
                  ],
                ),
              ),
            ),
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
    final card = CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              // *  YOUR WIDGETS HERE
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
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ],

      
    );
    return GestureDetector(
      child: card,
      onTap: () {
        print(isMovie);
        if (!isMovie) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (conetex) => NetworkInfo(
                    id: network.id,
                    title: network.name,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (conetex) => CompanyInfo(
                    id: network.id,
                    title: network.name,
                  )));
        }
      },
    );
  }
}
