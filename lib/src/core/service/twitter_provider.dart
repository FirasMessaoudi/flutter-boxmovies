import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

import 'auth_service.dart';
import 'facebook_provider.dart';

class TwitterProvider extends ChangeNotifier {
  final _auth = AuthService();
  final twitterLogin = TwitterLogin(
    consumerKey: "4jErRhY1SDL0XfH8gaRdAtjxN",
    consumerSecret: "PlKsa5re3857sjsSIrFe1tj5m1ArFPMXODuSo0Z67BZd7KJalU",
  );

  Future<Resource?> signInWithTwitter() async {
    final authResult = await twitterLogin.authorize();

    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential twitterAuthCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.session.token!,
                secret: authResult.session.secret);

        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(twitterAuthCredential);
        _auth.saveUser(
            userCredential.user!.displayName, userCredential.user!.email);
        return Resource(status: Status.Success);
      case TwitterLoginStatus.cancelledByUser:
        return Resource(status: Status.Success);
      case TwitterLoginStatus.error:
        return Resource(status: Status.Error);
      default:
        return null;
    }
  }

  Future logout() async {
    bool isLoggedIn = await twitterLogin.isSessionActive;
    if (isLoggedIn) await twitterLogin.logOut();
  }
}
