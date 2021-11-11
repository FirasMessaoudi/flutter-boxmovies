import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviebox/src/screens/auth/login_page.dart';
import 'package:moviebox/src/screens/auth/socials.dart';
import 'package:moviebox/src/screens/auth/title.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/util/validators.dart';
import 'package:moviebox/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/service/auth_service.dart';
import 'bezier_container.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;
  String email = '';
  String password = '';
  String name = '';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
            ),
            Text('login.back'.tr(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title=='Password'?'login.password'.tr():title=='Name'?'login.name'.tr():'edit_profile.email'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                if (title == 'Email') {
                  widget.email = value.toString().trim();
                } else if (title == 'Password') {
                  widget.password = value;
                } else {
                  widget.name = value;
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
        onTap: () async {
          handleRegister();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white, redColor])),
          child: Text(
            'login.register'.tr(),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                  
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'login.have_account'.tr(),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'login.login'.tr(),
              style: TextStyle(
                  color: redColor, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Name"),
        _entryField("Email"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    TitleLogin(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: 30),
                    _divider(),
                    Socials(action: 'signup'),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 1, color: Colors.white),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  handleRegister() async {
    final _auth = Provider.of<AuthService>(context,listen: false);

    try {
       if (!isEmail(widget.email) && widget.password.length<6){
          showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('login.validation_error'.tr()),
                content: Text('login.validation_message'.tr()),
              ));
              return;
      }
      showLoaderDialog(context);
      UserCredential? user =  await _auth.signup(widget.email, widget.password);
      print(user);
      if(user!=null){
      await _auth.saveUser(widget.name, widget.email);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('login.register_success'.tr()),
          duration: Duration(seconds: 5),
        ),
        // duration: Duration(seconds: 5),
      );
      Navigator.of(context).pop();
      } else {
        Navigator.pop(context);
         showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('login.register_failed'.tr()),
                content: Text('login.email_exist'.tr()),
              ));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(' Ops! Registration Failed'),
                content: Text('${e.message}'),
              ));
    }
  }
}
