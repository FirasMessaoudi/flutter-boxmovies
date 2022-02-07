import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSingIn = GoogleSignIn();
  final _auth = AuthService();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(
      [bool link = false, AuthCredential? authCredential]) async {
    await logoutGoogle();
    final googleUser = await googleSingIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credentials);
    if (userCredential.user != null) {
      await _auth.saveUser(FirebaseAuth.instance.currentUser!.displayName,
          FirebaseAuth.instance.currentUser!.email);
    }
    if (link) {
      await linkProviders(userCredential, authCredential!);
    }
    notifyListeners();
  }

  Future<UserCredential?> linkProviders(
      UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user!.linkWithCredential(newCredential);
  }

  Future logoutGoogle() async {
    bool isSignedIn = await googleSingIn.isSignedIn();
    if (isSignedIn) await googleSingIn.disconnect();
  }

  Future isSignedIn() async {
    bool isSignedIn = await googleSingIn.isSignedIn();
    return isSignedIn;
  }
}
