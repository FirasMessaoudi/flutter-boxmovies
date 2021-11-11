import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/collection_tab/collection_tab_bloc.dart';
import 'package:moviebox/src/core/model/movie_info_model.dart';
import 'package:moviebox/src/core/model/user.dart';
import 'package:moviebox/src/screens/watchlist/add_to_watchlist_fav.dart';
import 'package:moviebox/src/screens/home/navigation.dart';
import 'package:moviebox/src/screens/profile/edit_profile.dart';
import 'package:moviebox/src/core/service/auth_service.dart';
import 'package:moviebox/src/core/service/facebook_provider.dart';
import 'package:moviebox/src/core/service/google_provider.dart';
import 'package:moviebox/src/core/service/twitter_provider.dart';
import 'package:moviebox/src/screens/collection/collection_tab.dart';
import 'package:moviebox/src/screens/favorite/favorite_tab.dart';
import 'package:moviebox/src/screens/watchlist/watchlist_tab.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/widget/image_view.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../themes.dart';

class ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final AuthService _auth = new AuthService();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {},
                icon: DecoratedIcon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            )
          ],
          leading: IconButton(
            icon: DecoratedIcon(
              Icons.arrow_back_sharp,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder(
            future: _auth.findUserData(),
            builder: (BuildContext context, AsyncSnapshot<MyUser?> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child:
                                  GestureDetector(
                                 onTap: (){
                                   if(snapshot.data!.cover!=null)
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                         builder: (context) => ViewPhotos(
                                           imageList: [
                                             ImageBackdrop(image: snapshot.data!.cover),
                                           ],
                                           imageIndex: 0,
                                           color: Colors.white,
                                         ),
                                       ),
                                     );
                                 },

                                  child:Container(
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: (snapshot.data!.cover!=null && snapshot.data!.cover!='')?NetworkImage(snapshot.data!.cover) as ImageProvider:AssetImage(
                                                'assets/img/adventure.jpg'))),
                                  ),
                                ))
                              ],
                            ),
                            Positioned(
                              top: 170.0,
                              child:
                              GestureDetector(
                                onTap: (){
                                  if(snapshot.data!.photo!=null || user.photoURL!=null)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewPhotos(
                                        imageList: [
                                          ImageBackdrop(image: snapshot.data!.photo!=null?snapshot.data!.photo:user.photoURL!),
                                        ],
                                        imageIndex: 0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              child:Container(
                                height: 130.0,
                                width: 130.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: snapshot.data!.photo!=null?NetworkImage(snapshot.data!.photo):user.photoURL!=null
                                          ? NetworkImage(user.photoURL!)
                                          : AssetImage(
                                                  'assets/img/avatarprofile.png')
                                              as ImageProvider,
                                    ),
                                    border: Border.all(
                                        color: Colors.white, width: 3.0)),
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data!.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),

                       /*   SizedBox(
                            width: 5.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => new EditProfile(user: snapshot.data!)));
                            },
                          )*/
                        ],
                      ),
                      SizedBox(height: 12.0,),
                      Container(
                          child: Text(snapshot.data!.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Spectral',
                            fontStyle: FontStyle.italic

                          ),)
                      ),
                      SizedBox(height: 10.0,),
                      Card(
                         margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20.0),
                        clipBehavior: Clip.antiAlias,
                       // color: Colors.grey,
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "info_user.episode_watched".tr(),
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "5200",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                       // color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "info_user.movie_watched".tr(),
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "28.5K",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                       // color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Column(children: <Widget>[
                          ProfileListItem(
                            icon: Icons.favorite,
                            text: 'info_user.fav'.tr(),
                            item:ProfileItems.fav,
                            user: snapshot.data!,
                          ),
                          ProfileListItem(
                            icon: Icons.tv,
                            text: 'info_user.my_shows'.tr(),
                            item:ProfileItems.series,
                            user: snapshot.data!,

                          ),
                          ProfileListItem(
                            icon: Icons.movie,
                            text: 'info_user.my_movies'.tr(),
                            item:ProfileItems.movies,
                            user: snapshot.data!,

                          ),

                          ProfileListItem(
                            icon: Icons.list,
                            text: 'info_user.custom_lists'.tr(),
                            item:ProfileItems.collections,
                            user: snapshot.data!,

                          ),
                          ProfileListItem(
                            icon: Icons.legend_toggle,
                            text: 'info_user.stat'.tr(),
                            item:ProfileItems.stat,
                            user: snapshot.data!,

                          ),
                          ProfileListItem(
                            icon: Icons.settings,
                            text: 'info_user.settings'.tr(),
                            item:ProfileItems.settings,
                            user: snapshot.data!,

                          ),
                          ProfileListItem(
                            icon: Icons.logout,
                            text: 'info_user.logout'.tr(),
                            item:ProfileItems.logout,
                            hasNavigation: false,
                            user: snapshot.data!,

                          ),
                        ]),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: redColor,
                ));
              } else {
                return Center(child: Text('No user found'));
              }
            })
            );


  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final ProfileItems item;
  final MyUser user;
  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.item,
    this.hasNavigation = true,
    required this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context, listen: false);
    final googleProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final fbProvider = Provider.of<FacebookProvider>(context, listen: false);
    final twitterProvider = Provider.of<TwitterProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        if (!this.hasNavigation) {
          await _auth.signOut();
          await fbProvider.logoutFromFb();
          await googleProvider.logoutGoogle();
          await twitterProvider.logout();
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        }
        if (item == ProfileItems.settings) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new EditProfile(user: user)));
        }
        if(item==ProfileItems.movies || item==ProfileItems.series){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new WatchlistTab(type:item)));
        }
        if (item == ProfileItems.fav) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new FavoritesTab()));
        }
        if (item == ProfileItems.collections) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  BlocProvider<CollectionTabBloc>(
                create: (context) => CollectionTabBloc()..add(LoadCollections()),
                child: CollectionsTab(),
              ),));
        }

      },
      child: Container(
        height: 55,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 20,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
            border: Border.all(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black, width: 1)),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: 25,
            ),
            SizedBox(width: 15),
            Text(
              this.text,
              style: kTitleTextStyle.copyWith(
                  fontWeight: FontWeight.w500, fontFamily: "Poppins"),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                Icons.arrow_right,
                size: 25,
              ),
          ],
        ),
      ),
    );
  }
}
