import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviebox/core/service/user.service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreInstance = FirebaseFirestore.instance;
  final UserService userService = Get.find();
  final googleSingIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  final twitterLogin = TwitterLogin(
    consumerKey: "4jErRhY1SDL0XfH8gaRdAtjxN",
    consumerSecret: "PlKsa5re3857sjsSIrFe1tj5m1ArFPMXODuSo0Z67BZd7KJalU",
  );
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signup(String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      return null;
    }
  }



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
      await userService.saveUser(FirebaseAuth.instance.currentUser!.displayName,
          FirebaseAuth.instance.currentUser!.email);
    }
    if (link) {
      await linkProviders(userCredential, authCredential!);
    }
  }

  Future<UserCredential?> linkProviders(
      UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user!.linkWithCredential(newCredential);
  }

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
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookCredential);
          await userService.saveUser(FirebaseAuth.instance.currentUser!.displayName,
              FirebaseAuth.instance.currentUser!.email);
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
        userService.saveUser(
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

  Future logoutTwitter() async {
    bool isLoggedIn = await twitterLogin.isSessionActive;
    if (isLoggedIn) await twitterLogin.logOut();
  }

  Future logoutFromFb() async {
    await FacebookAuth.instance.logOut();
  }

  Future logoutGoogle() async {
    bool isSignedIn = await googleSingIn.isSignedIn();
    if (isSignedIn) await googleSingIn.disconnect();
  }

  Future isSignedIn() async {
    bool isSignedIn = await googleSingIn.isSignedIn();
    return isSignedIn;
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await logoutTwitter();
    await logoutFromFb();
    await logoutGoogle();
    await _auth.signOut();
  }

  User? getCurrentUser() => FirebaseAuth.instance.currentUser??null;





}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
