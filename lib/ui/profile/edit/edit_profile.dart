import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviebox/core/model/user.model.dart';
import 'package:moviebox/core/service/notification.service.dart';
import 'package:moviebox/shared/util/theme_switch.dart';
import 'package:moviebox/shared/util/utilities.dart';
import 'package:moviebox/shared/widget/appbar.dart';
import 'package:moviebox/ui/profile/language_widget.dart';
import 'package:moviebox/ui/profile/profile.controller.dart';
import 'package:moviebox/ui/profile/info/profile_info.dart';

import '../../../themes.dart';

class EditProfile extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Get.isDarkMode
              ? Colors.white
              : Colors.black,
          child: const Icon(Icons.save, color: Colors.red),
          onPressed: () async {
            updateUser();
          },
        ),
        appBar: DefaultAppBar(title: 'edit_profile.title'.tr,),
        body: Stack(children: [
          SettingsList(
            sections: [
              SettingsSection(
                titlePadding: EdgeInsets.all(20),
                title: 'edit_profile.general_info'.tr,
                titleTextStyle: TextStyle(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
                tiles: [
                  SettingsTile(
                    title: 'edit_profile.photo'.tr,
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
                                    await controller.picker.pickImage(source: ImageSource.camera);
                                    controller.imageFile = File(pickedFile!.path);
                                   controller.isSelected = true;
                                    Navigator.of(context).pop();

                              },
                              child: const Text('Camera'),
                            ),
                            SimpleDialogOption(
                              onPressed: () async{
                                final pickedFile = await controller.picker.pickImage(source: ImageSource.gallery);
                                controller.imageFile = File(pickedFile!.path);
                                controller.isSelected = true;
                                Navigator.of(context).pop();

                              },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      });
                      

                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.cover'.tr,
                    leading: displayedCover(),
                    onPressed: (BuildContext context) async {
                      showDialog(context: context, builder: (BuildContext context){
                        return SimpleDialog(
                          title: const Text('Select Source'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () async{
                                final pickedFile =
                                await controller.picker.pickImage(source: ImageSource.camera);
                                    controller.coverFile = File(pickedFile!.path);
                                   controller.isSelectedCover = true;
                                    Navigator.of(context).pop();

                              },
                              child: const Text('Camera'),
                            ),
                            SimpleDialogOption(
                              onPressed: () async{ final pickedFile =
                              await controller.picker.pickImage(source: ImageSource.gallery);
                              controller.coverFile = File(pickedFile!.path);
                              controller.isSelectedCover = true;
                              Navigator.of(context).pop();
                              },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      });


                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.quote'.tr,
                    subtitle: controller.description != ''
                        ? controller.description
                        : controller.user.value.description != '.'
                            ? controller.user.value.description
                            : 'edit_profile.description'.tr,
                    leading: Icon(Icons.info),
                    onPressed: (BuildContext context) {
                      _displayDescriptionInputDialog(context);
                    },
                  ),
                ],
              ),
              SettingsSection(
                titlePadding: EdgeInsets.all(20),
                title: 'edit_profile.personal_info'.tr,
                titleTextStyle: TextStyle(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
                tiles: [
                  SettingsTile(
                    title: 'edit_profile.email'.tr,
                    subtitle: controller.user.value.email,
                    leading: Icon(Icons.email),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'edit_profile.name'.tr,
                    subtitle: controller.name != '' ? controller.name : controller.user.value.name,
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.edit),
                    onPressed: (BuildContext context) async {
                      _displayTextInputDialog(context);
                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.birthdate'.tr,
                    subtitle: controller.birthdate != ''
                        ? controller.birthdate
                        : controller.user.value.birthdate != null
                            ? controller.user.value.birthdate
                            : 'N/A',
                    leading: Icon(Icons.calendar_today),
                    trailing: Icon(Icons.edit),
                    onPressed: (BuildContext context) async {
                      _selectDate();
                    },
                  ),
                  SettingsTile(
                    title: 'edit_profile.country'.tr,
                    subtitle: controller.selectedCountry != ''
                        ? controller.selectedCountry
                        : controller.user.value.country != null
                            ? controller.user.value.country
                            : 'N/A',
                    leading: Icon(Icons.flag),
                    trailing: dropdown(),
                    onPressed: (BuildContext context) {},
                  ),
                ],
              ),
              SettingsSection(
                  titlePadding: EdgeInsets.all(20),
                  title: 'edit_profile.settings'.tr,
                  titleTextStyle: TextStyle(
                      color: Get.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold),
                  tiles: [
                    SettingsTile(
                      title: 'edit_profile.language'.tr,
                      subtitle: Get.locale!.languageCode == 'en'
                          ? 'English'
                          : Get.locale!.languageCode == 'ar'
                              ? 'Arabic'
                              : 'Français',
                      leading: Icon(Icons.language),
                      trailing: LanguageWidget(),
                      onPressed: (BuildContext context) {},
                    ),
                    SettingsTile(
                      title: Get.isDarkMode
                          ? 'edit_profile.light_mode'.tr
                          : 'edit_profile.dark_mode'.tr,
                      leading: Get.isDarkMode
                          ? Icon(Icons.wb_sunny)
                          : Icon(Icons.brightness_3),
                      onPressed: (BuildContext context) {
                        controller.switchTheme();
                        Get.changeThemeMode(Get.isDarkMode?ThemeMode.light:ThemeMode.dark);
                      },
                    ),
                  ])
            ],
          ),
        ]));
    // TODO: implement build
  }

  Future updateUser() async {
    String photoPath = '';
    String coverPath = '';
    MyUser userToUpdate = controller.user.value;
    if (controller.isSelected) {
      photoPath = await uploadImageToFirebase('photo', controller.imageFile);
      userToUpdate.photo = photoPath;
    }
    if (controller.isSelectedCover) {
      coverPath = await uploadImageToFirebase('cover', controller.coverFile);
      userToUpdate.cover = coverPath;
    }
    if (controller.name != '') {
      userToUpdate.name = controller.name;
    }
    if (controller.birthdate != '') {
      userToUpdate.birthdate = controller.birthdate;
    }
    if (controller.selectedCountry != '') {
      userToUpdate.country = controller.selectedCountry;
    }
    if (controller.description != '') {
      userToUpdate.description = controller.description;
    }
    await controller.updateUser(userToUpdate);
    NotificationService.successSnackbar('Success', 'User Updated successfully');
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
    if (!controller.isSelected) {
      if (controller.user.value.photo == '' || controller.user.value.photo == null) {
        return Icon(Icons.photo);
      } else {
        return Image.network(controller.user.value.photo);
      }
    } else {
      return Image.file(controller.imageFile);
    }
  }

  Widget displayedCover() {
    if (!controller.isSelectedCover) {
      if (controller.user.value.cover == '' || controller.user.value.cover == null) {
        return Icon(Icons.photo);
      } else {
        return Image.network(controller.user.value.cover);
      }
    } else {
      return Image.file(controller.coverFile);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    controller.name = controller.user.value.name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('edit_profile.name'.tr),
            content: TextField(
              onChanged: (value) {

                controller.name = value;

              },
              controller: controller.textFieldController,
              decoration: InputDecoration(hintText: controller.name),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayDescriptionInputDialog(BuildContext context) async {
    controller.description = controller.user.value.description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('edit_profile.description'.tr),
            content: TextField(
              maxLines: 4,
              onChanged: (value) {
                controller.description = value;

              },
              controller: controller.textFieldControllerDescription,
              decoration: InputDecoration(hintText: controller.description),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {

                    //  codeDialog = valueText;
                    Navigator.pop(context);

                },
              ),
            ],
          );
        });
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null)

      controller.birthdate = controller.f.format(picked).toString();
  }

  Widget dropdown() {
    return Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: DropdownButton<String>(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Get.isDarkMode
                ? Colors.white
                : Colors.black,
          ),
          underline: Container(
            height: 2,
            color: Colors.transparent,
          ),
          onChanged: (String? value) async {
                controller.selectedCountry = value!;

          },
          items: countries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                }).toList(),
        ));
  }
}
