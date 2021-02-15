import 'package:flutter/material.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';

final List<SettingItems> settingsitems = [
  SettingItems(
      image: Image.asset(
        ImageAssests.password,
        height: 20.0,
        width: 20.0,
      ),
      title: changePassword),
  SettingItems(
      image: Image.asset(
        ImageAssests.locationIcon,
        height: 20.0,
        width: 20.0,
      ),
      title: locationSettings),
  SettingItems(
      image: Image.asset(
        ImageAssests.bellIcon,
        height: 20.0,
        width: 20.0,
      ),
      title: notifications),
  SettingItems(
      image: Image.asset(
        ImageAssests.privacyPolicy,
        height: 20.0,
        width: 20.0,
      ),
      title: privacyPolicy),
  SettingItems(
      image: Image.asset(
        ImageAssests.termsCondition,
        height: 20.0,
        width: 20.0,
      ),
      title: TermsCondition),
  SettingItems(
      image: Image.asset(
        ImageAssests.logout,
        height: 20.0,
        width: 20.0,
      ),
      title: logout),
];

class SettingItems {
  SettingItems({
    this.image,
    this.title,
  });

  Image image;
  String title;
}
