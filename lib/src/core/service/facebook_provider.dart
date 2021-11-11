import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class FacebookProvider extends ChangeNotifier {
      final _auth  = AuthService();

  Future<Resource?> signInWithFacebook() async {
      try {
        await logoutFromFb();
      final LoginResult result = await FacebookAuth.instance.login(
            permissions: ['public_profile', 'email'],

      );
    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(facebookCredential);
            await _auth.saveUser(FirebaseAuth.instance.currentUser!.displayName, FirebaseAuth.instance.currentUser!.email);
            notifyListeners();

        return Resource(status: Status.Success);
      case LoginStatus.cancelled:
        return Resource(status: Status.Cancelled);
      case LoginStatus.failed:
        return Resource(status: Status.Error);
      default:
        return null;
      
      }
      } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
   Future logoutFromFb () async {
    await FacebookAuth.instance.logOut();
  }
  
}
class Resource{

   final Status status;
  Resource({required this.status});
}

enum Status {
  Success,
  Error,
  Cancelled

}