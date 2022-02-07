import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moviebox/src/core/model/user.dart';
import 'package:moviebox/src/core/service/auth_service.dart';
import 'package:moviebox/src/screens/profile/profile_info.dart';
import 'package:moviebox/src/shared/util/theme_switch.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes.dart';

class EditProfile extends StatefulWidget {
  final MyUser user;

  EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isSwitched = true;
  final picker = ImagePicker();
  bool isSelected = false;
  bool isSelectedCover = false;
  late File _imageFile;
  late File _coverFile;
  final AuthService _auth = new AuthService();
  String name = '';
  String description = '';
  TextEditingController _textFieldController = new TextEditingController();
  TextEditingController _textFieldControllerDescription =
      new TextEditingController();
  String birthdate = '';
  final f = new DateFormat('dd/MM/yyyy');
  String selectedCountry = '';
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          child: const Icon(Icons.save, color: Colors.red),
          onPressed: () async {
            updateUser();
          },
        ),
        appBar: new AppBar(
          elevation: 0,
          // brightness: Brightness.dark,
          centerTitle: true,
          title: Text('edit_profile.title'.tr(),
              style: heading.copyWith(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileAppBar(),
                ),
              );
            },
          ),
        ),
        body: Stack(children: [
          SettingsList(
            sections: [
              SettingsSection(
                titlePadding: EdgeInsets.all(20),
                title: 'edit_profile.general_info'.tr(),
                titleTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
                tiles: [
                  SettingsTile(
                    title: 'edit_profile.photo'.tr(),
                    // subtitle: 'English',
                    leading: displayedImage(),
                    onPressed: (BuildContext context) async {
                      showDialog(context: context, builder: (BuildContext context){
                        return SimpleDialog(
                          title: const Text('Select Source'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () async{
                                final pickedFile =
                                    await picker.pickImage(source: ImageSource.camera);
                                if (mounted)
                                  setState(() {
                                    _imageFile = File(pickedFile!.path);
                                    isSelected = true;
                                    Navigator.of(context).pop();
                                  });
                              },
                              child: const Text('Camera'),
                            ),
                            SimpleDialogOption(
                              onPressed: () async{ final pickedFile =
                                  await picker.pickImage(source: ImageSource.gallery);
                              if (mounted)
                                setState(() {
                                  _imageFile = File(pickedFile!.path);
                                  isSelected = true;
                                  Navigator.of(context).pop();

                                }); },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      });
                      

                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.cover'.tr(),
                    leading: displayedCover(),
                    onPressed: (BuildContext context) async {
                      showDialog(context: context, builder: (BuildContext context){
                        return SimpleDialog(
                          title: const Text('Select Source'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () async{
                                final pickedFile =
                                await picker.pickImage(source: ImageSource.camera);
                                if (mounted)
                                  setState(() {
                                    _coverFile = File(pickedFile!.path);
                                    isSelectedCover = true;
                                    Navigator.of(context).pop();
                                  });
                              },
                              child: const Text('Camera'),
                            ),
                            SimpleDialogOption(
                              onPressed: () async{ final pickedFile =
                              await picker.pickImage(source: ImageSource.gallery);
                              if (mounted)
                                setState(() {
                                  _coverFile = File(pickedFile!.path);
                                  isSelectedCover = true;
                                  Navigator.of(context).pop();

                                }); },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      });


                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.quote'.tr(),
                    subtitle: description != ''
                        ? description
                        : widget.user.description != ''
                            ? widget.user.description
                            : 'edit_profile.description'.tr(),
                    leading: Icon(Icons.info),
                    onPressed: (BuildContext context) {
                      _displayDescriptionInputDialog(context);
                    },
                  ),
                ],
              ),
              SettingsSection(
                titlePadding: EdgeInsets.all(20),
                title: 'edit_profile.personal_info'.tr(),
                titleTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
                tiles: [
                  SettingsTile(
                    title: 'edit_profile.email'.tr(),
                    subtitle: widget.user.email,
                    leading: Icon(Icons.email),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'edit_profile.name'.tr(),
                    subtitle: name != '' ? name : widget.user.name,
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.edit),
                    onPressed: (BuildContext context) async {
                      _displayTextInputDialog(context);
                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.birthdate'.tr(),
                    subtitle: birthdate != ''
                        ? birthdate
                        : widget.user.birthdate != null
                            ? widget.user.birthdate
                            : 'N/A',
                    leading: Icon(Icons.calendar_today),
                    trailing: Icon(Icons.edit),
                    onPressed: (BuildContext context) async {
                      _selectDate();
                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.country'.tr(),
                    subtitle: selectedCountry != ''
                        ? selectedCountry
                        : widget.user.country != null
                            ? widget.user.country
                            : 'N/A',
                    leading: Icon(Icons.flag),
                    trailing: dropdown('country'),
                    onPressed: (BuildContext context) {},
                  ),
                ],
              ),
              SettingsSection(
                  titlePadding: EdgeInsets.all(20),
                  title: 'edit_profile.settings'.tr(),
                  titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold),
                  tiles: [
                    SettingsTile(
                      title: 'edit_profile.language'.tr(),
                      subtitle: context.locale.languageCode == 'en'
                          ? 'English'
                          : context.locale.languageCode == 'ar'
                              ? 'Arabic'
                              : 'Français',
                      leading: Icon(Icons.language),
                      trailing: dropdown('language'),
                      onPressed: (BuildContext context) {},
                    ),
                    SettingsTile(
                      title: Theme.of(context).brightness == Brightness.dark
                          ? 'edit_profile.light_mode'.tr()
                          : 'edit_profile.dark_mode'.tr(),
                      leading: Theme.of(context).brightness == Brightness.dark
                          ? Icon(Icons.wb_sunny)
                          : Icon(Icons.brightness_3),
                      onPressed: (BuildContext context) {
                        Provider.of<MyTheme>(context, listen: false)
                            .switchTheme();
                      },
                    ),
                  ])
            ],
          ),
        ]));
    // TODO: implement build
  }

  Future updateUser() async {
    showLoaderDialog(context);
    String photoPath = '';
    String coverPath = '';
    MyUser userToUpdate = widget.user;
    if (isSelected) {
      photoPath = await uploadImageToFirebase('photo', _imageFile);
      userToUpdate.photo = photoPath;
    }
    if (isSelectedCover) {
      coverPath = await uploadImageToFirebase('cover', _coverFile);
      userToUpdate.cover = coverPath;
    }
    if (name != '') {
      userToUpdate.name = name;
    }
    if (birthdate != '') {
      userToUpdate.birthdate = birthdate;
    }
    if (selectedCountry != '') {
      userToUpdate.country = selectedCountry;
    }
    if (description != '') {
      userToUpdate.description = description;
    }
    await _auth.updateUser(userToUpdate);
    Navigator.of(context).pop();
  }

  Future<String> uploadImageToFirebase(String type, File file) async {
    String fileName = "photo" + DateTime.now().toString();
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    final dowurl = await (await uploadTask).ref.getDownloadURL();
    return dowurl.toString();
  }

  Widget displayedImage() {
    if (!isSelected) {
      if (widget.user.photo == '' || widget.user.photo == null) {
        return Icon(Icons.photo);
      } else {
        return Image.network(widget.user.photo);
      }
    } else {
      return Image.file(_imageFile);
    }
  }

  Widget displayedCover() {
    if (!isSelectedCover) {
      if (widget.user.cover == '' || widget.user.cover == null) {
        return Icon(Icons.photo);
      } else {
        return Image.network(widget.user.cover);
      }
    } else {
      return Image.file(_coverFile);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    name = widget.user.name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('edit_profile.name'.tr()),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: name),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayDescriptionInputDialog(BuildContext context) async {
    description = widget.user.description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('edit_profile.description'.tr()),
            content: TextField(
              maxLines: 4,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              controller: _textFieldControllerDescription,
              decoration: InputDecoration(hintText: description),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() => {
            birthdate = f.format(picked).toString(),
          });
  }

  Widget dropdown(String title) {
    return Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: DropdownButton<String>(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          underline: Container(
            height: 2,
            color: Colors.transparent,
          ),
          onChanged: (String? value) {
            setState(() async {
              if (title == 'country')
                selectedCountry = value!;
              else {
                selectedLanguage = value;
                if (value == 'English') {
                  this.setState(() async {
                    context.setLocale(Locale('en', 'US'));
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString('language', 'en-US');
                  });
                } else if (value == 'French') {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('language', 'fr-FR');
                  context.setLocale(Locale('fr', 'FR'));
                } else if (value == 'Arabic') {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('language', 'ar-SA');
                  context.setLocale(Locale('ar', 'SA'));
                } else if (value == 'Spanish') {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('language', 'es-ES');
                  context.setLocale(Locale('es', 'ES'));
                } else if (value == 'Italian') {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('language', 'it-IT');
                  context.setLocale(Locale('it', 'IT'));
                }
              }
            });
          },
          items: title == 'language'
              ? <String>['English', 'French', 'Arabic', 'Spanish', 'Italian']
                  .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                }).toList()
              : countries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                }).toList(),
        ));
  }
}
