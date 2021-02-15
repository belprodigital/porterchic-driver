import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porterchic_driver/app_screen/changepassword.dart';
import 'package:porterchic_driver/app_screen/locationsettings.dart';
import 'package:porterchic_driver/app_screen/notificationsscreen.dart';
import 'package:porterchic_driver/app_screen/previewsScreen.dart';
import 'package:porterchic_driver/app_screen/privacy_policy.dart';
import 'package:porterchic_driver/app_screen/terms&conditions.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/model/settingsmodel.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {




  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String deviceToken= "";
  var firebaseMessging = FirebaseMessaging();

  @override
  void initState() {
    firebaseMessging.getToken().then((value){
      deviceToken = value;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white_color,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white_color,
          title: CustomtextFields.textFields(
            text: settings,
            textColor: blackColor,
            fontFamily: 'JosefinSans',

            fontWeight: FontWeight.w500,
            fontSize: 24.0,
          ),
          titleSpacing: 0.0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              BackIcon.union,
              size: 14.0,
              color: blackColor,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: settingsitems.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0),
          itemBuilder: (context, int index) {
            return GestureDetector(
              child: setting(index),
              onTap: () {
                (index == 5)
                    ? _settingModelBottomSheet(context)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              navigateToOtherScreen(index, context),
                        ),
                      );

              },
            );
          },
        ));
  }

  Widget navigateToOtherScreen(int index, context) {
    if (index == 0) {
      return ChangePasswordScreen(texts: settingsitems[index].title);
    } else if (index == 1) {
      return LocationSettingsScreen(texts: settingsitems[index].title);
    } else if (index == 2) {
      return NotificationScreen(texts: settingsitems[index].title);
    } else if (index == 3) {
      return PrivacyPolicyScreen();
    } else if (index == 4) {
      return TermsAndConditionsScreen();
    }
  }

  Widget setting(int index) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(left: 20.0, right: 20.0,),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      settingsitems[index].image,
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: CustomtextFields.textFields(
                          text: settingsitems[index].title,
                          textColor: blackColor,
                            fontFamily: 'JosefinSans',
                            fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          textAlign: TextAlign.start
                        )
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  ImageAssests.arrowright,
                   color: textColor,
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

   _settingModelBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 40.0,bottom: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomtextFields.textFields(
                    text: wantLogout,
                    fontSize: 24.0,
                    fontFamily: 'JosefinSans',

                    textColor: black_color,
                    fontWeight: FontWeight.w500),
                SizedBox(
                  height: 20.0,
                ),
                /*CustomtextFields.textFields(
                    fontSize: 16.0,
                    textOverflow: TextOverflow.ellipsis,
                    fontFamily: 'JosefinSans',

                    text:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    textColor: textColor,
                     textAlign: TextAlign.center,
                    maxLines: 3),
                SizedBox(
                  height: 30.0,
                ),*/
                CustomButtons.loginButton(
                    fontSize: 16.0,
                    textColor: white_color,
                    backgroundColor: buttonColor,
                    radiusSize: 2.0,
                    text: yesLogout,
                    function: () {
                      SharedPreferences.getInstance().then((sharedPreferences) async {
                        Map<String,dynamic> param = Map();
                        param["device_token"]=deviceToken;
                        await NetworkCall().callPostApi(param, ApiConstants.logout);
                        sharedPreferences.clear();
                        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                          builder: (context)=>PreviewScreen()
                        ), (route) => false);
                      });
                    }
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).pop();
                  },
                  child: CustomtextFields.textFields(
                      fontSize: 16.0,
                      fontFamily: 'JosefinSans',

                      fontWeight: FontWeight.w700,
                      textOverflow: TextOverflow.ellipsis,
                      text: stayInSystem,
                      textColor: textColor,
                       textAlign: TextAlign.center),
                ),
              ],
            ),
          );
        });
  }
}
