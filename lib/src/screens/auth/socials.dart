import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviebox/src/screens/home/navigation.dart';
import 'package:moviebox/src/core/service/facebook_provider.dart';
import 'package:moviebox/src/core/service/google_provider.dart';
import 'package:moviebox/src/core/service/twitter_provider.dart';
import 'package:moviebox/src/shared/util/login_type.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/themes.dart';
import 'package:provider/provider.dart';

class Socials extends StatelessWidget {
  final String action;

  const Socials({Key? key, required this.action}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: MaterialButton(
            onPressed: () async {
              loginWithProvider(LoginType.facebook, context);
            },
            color: Color(0xFF3b5998),
            textColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.facebookF,
              size: 22,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
        // SizedBox(width: 10,),
        Container(
          child: MaterialButton(
            onPressed: () async {
              loginWithProvider(LoginType.google, context);
            },
            color: Color(0xFFEA4335),
            textColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.google,
              size: 22,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
        Container(
          child: MaterialButton(
            onPressed: () async {
              loginWithProvider(LoginType.twitter, context);
            },
            color: Color.fromRGBO(29, 161, 242, 1),
            textColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.twitter,
              size: 22,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }

  void loginWithProvider(LoginType loginType, BuildContext context) async {
    switch (loginType) {
      case LoginType.facebook:
        {
          try {
            showLoaderDialog(context);
            final provider =
                Provider.of<FacebookProvider>(context, listen: false);
            final Resource? response = await provider.signInWithFacebook();
            print(response?.status);
            if (response?.status == Status.Success) {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (contex) => Home(),
                ),
              );
            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              Navigator.of(context).pop(context);
              showMessage(e, context);
            }
          }
        }
        break;
      case LoginType.google:
        {
          showLoaderDialog(context);
          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
          await provider.googleLogin();
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (contex) => Home(),
            ),
          );
        }
        break;
      case LoginType.twitter:
        {
          showLoaderDialog(context);
          final provider = Provider.of<TwitterProvider>(context, listen: false);
          try {
            final Resource? response = await provider.signInWithTwitter();
            if (response?.status == Status.Success) {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (contex) => Home(),
                ),
              );
            } else {
              Navigator.of(context).pop(context);
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text(' Ops! Login failed'),
                        content: Text('Error while login with twitter'),
                      ));
            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              Navigator.of(context).pop(context);
              showMessage(e, context);
            }
          }
        }
    }
  }

  void showMessage(FirebaseAuthException e, BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message!),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                  print(e.code);
                  if (e.code == 'account-exists-with-different-credential') {
                    List<String> emailList = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(e.email!);
                    if (emailList.first == "google.com") {
                      await provider.googleLogin(true, e.credential);
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (contex) => Home(),
                        ),
                      );
                    }
                  }
                },
              )
            ],
          );
        });
  }
}
