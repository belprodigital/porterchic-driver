import 'package:flutter/material.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';

final List<PersonalInfo> personalinformation = [
  PersonalInfo(
      symbol: Image.asset(
          ImageAssests.accountIcon, color: white_color, scale: 3.0),
      title: personalInfo,
      subtitle: managePersonalInfo),
  PersonalInfo(
      symbol: Image.asset(ImageAssests.rating, color: white_color, scale: 3.0),
      title: myRatings,
      subtitle: ratingSubtitle),
  PersonalInfo(
      symbol: Image.asset(ImageAssests.myDrive, color: white_color, scale: 3.0),
      title: myDrives,
      subtitle: myDrivesSubtitle),
  PersonalInfo(symbol: Image.asset(
      ImageAssests.settings, color: white_color, scale: 3.0),
      title: settings,
      subtitle: setUpApp),

];

class PersonalInfo {
  PersonalInfo({
    this.symbol,
    this.title,
    this.subtitle,
  });

  Image symbol;
  String title;
  String subtitle;
}
