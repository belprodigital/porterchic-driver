import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSettingsScreen extends StatefulWidget {
  final String texts;

  // receive data from the FirstScreen as a parameter
  LocationSettingsScreen({Key key, @required this.texts}) : super(key: key);

  @override
  _LocationSettingsScreenState createState() =>
      _LocationSettingsScreenState(texts);
}

class _LocationSettingsScreenState extends State<LocationSettingsScreen> {
  final String texts;
  bool isToggled = false;
  bool isLocationPermisionOn = false;
  Location location = Location();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPreferences){
      this.sharedPreferences = sharedPreferences;
      isLocationPermisionOn = sharedPreferences.getBool(ApiConstants.locationOff);
      if(isLocationPermisionOn!=null && isLocationPermisionOn){
        Permission.location.status.then((value) {
          print(value.isGranted);
          setState(() {
            isToggled = value.isGranted;
          });
        });
      }

    });
    super.initState();
  }

  _LocationSettingsScreenState(this.texts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white_color,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white_color,
        title: CustomtextFields.textFields(
          text: texts ?? changePassword,
          textColor: blackColor,
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 7.0, bottom: 7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: CustomtextFields.textFields(
                            text: locationPermission,
                            textAlign: TextAlign.start,
                            fontSize: 16.0,
                            textColor: blackColor)),
                    GestureDetector(
                        onTap: () {
                          if (!isToggled) {
                            getPermission();
                          } else {
                            sharedPreferences.setBool(ApiConstants.locationOff, false);
                            setState(() {
                              isToggled = !isToggled;
                            });
                          }
                        },
                        child: Image.asset(
                          isToggled
                              ? ImageAssests.switchOn
                              : ImageAssests.switchOff,
                          width: 32.0,
                          height: 30.0,
                        )),
                  ],
                ),
              ),
              Divider(),
             /* SizedBox(
                height: 20.0,
              ),
              CustomtextFields.textFields(
                  fontSize: 16.0,
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adip elit, sed do eiusmod tempor.",
                  textColor: textColor,
                  fontWeight: FontWeight.w400,
//                  textScaleFactor: 2.0,
                  textAlign: TextAlign.start,
                  maxLines: 2)*/
            ],
          ),
        ),
      ),
    );
  }

  Future getPermission() async {
    if(!await Permission.location.isGranted){
      if(await Permission.location.isUndetermined){
        Permission.location.request().then((value){
          if(value.isGranted){
            allowLocation();
          }
        });
      }else{
        openAppSettings();
      }
    }else{
      allowLocation();
    }
    /*location.hasPermission().then((value) async {
      print(await Permission.location.status);
      print(value.index);
      if (value.index == 0) {
        allowLocation();
      } else if (value.index == 1) {
        openAppSettings();
      } else {
        openAppSettings();
      }
    });*/
  }

  Future<void> allowLocation() async {
    print("allow locaton 1");
    if (!await location.serviceEnabled()) {
      print("allow locaton 1");
      location.requestService().then((value) {
        print("allow locaton 1");
        if (value) {
          sharedPreferences.setBool(ApiConstants.locationOff, true);
          isToggled = !isToggled;
        }
      });
    } else {
      sharedPreferences.setBool(ApiConstants.locationOff, true);
      setState(() {
        isToggled = !isToggled;
      });
    }
  }
}
