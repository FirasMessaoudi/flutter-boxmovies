import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/service/auth_service.dart';
import 'package:moviebox/src/screens/auth/login_page.dart';
import 'package:moviebox/src/screens/profile/profile_info.dart';
import 'package:moviebox/themes.dart';

class WelcomeScreen extends StatelessWidget {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (BuildContext _, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: redColor,
            ),
          );
        }
        //if the snapshot is null, or not has data it is signed out
        else if (!snapshot.hasData) return LoginPage();
        // if the snapshot is having data it is signed in, show the homescreen
        return ProfileAppBar();
      },
    );
  }
}
