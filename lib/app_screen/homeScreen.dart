import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:porterchic_driver/app_screen/home_map_screen.dart';
import 'package:porterchic_driver/app_screen/myDelieveriesScreen.dart';
import 'package:porterchic_driver/app_screen/notification_tab_screen.dart';
import 'package:porterchic_driver/app_screen/order_Info_screen.dart';
import 'package:porterchic_driver/app_screen/profile_screen.dart';
import 'package:porterchic_driver/app_screen/whatsapp_screen.dart';
import 'package:porterchic_driver/icons/bottombar_icon_icons.dart';
import 'package:porterchic_driver/model/user_data_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myratings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  int count;
  String userId;
  UserDataModel userDataModel;
  bool isKeyboardVisible = false;
  var firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    initFirebaseService();
    SharedPreferences.getInstance().then((sharedPreferences){
    userDataModel = UserDataModel.fromJson(json.decode(sharedPreferences.getString(ApiConstants.userData)));
    getNotificationCount();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          isKeyboardVisible = visible;
        });

      },
    );
  });
    super.initState();
  }

  final GlobalKey<NotificationTabScreenState> notificationTabScreenState =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            backgroundColor: white_color,
            body: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 14.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_currentTabIndex == 3) {
                                return;
                              }
                              setState(() {
                                _currentTabIndex = 3;
                              });
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 15.0),
                              child: Image.asset(
                                ImageAssests.supportIcon,
                                height: 20.0,
                                width: 20.0,
                              ))),
                      Image.asset(
                        ImageAssests.porterChicLogoBlue,
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ProfileScreen()));
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 15.0),
                            child: Image.asset(
                              ImageAssests.accountIcon,
                              height: 20.0,
                              width: 20.0,
                            )),
                      )
                    ],
                  ),
                ),
                Expanded(child: navigateToScreen(_currentTabIndex)),
              ],
            ),
            bottomNavigationBar: !isKeyboardVisible?Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: Image.asset(
                        ImageAssests.myDelivery,
                        height: 22.0,
                        color: _currentTabIndex == 0 ? blackColor : textColor,
                      ),
                      onPressed: () {
                        if (_currentTabIndex == 0) {
                          return;
                        }
                        setState(() {
                          _currentTabIndex = 0;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: Image.asset(
                        ImageAssests.mapIcon,
                        height: 22.0,
                        color: _currentTabIndex == 1 ? blackColor : textColor,
                      ),
                      onPressed: () {
                        if (_currentTabIndex == 1) {
                          return;
                        }
                        setState(() {
                          _currentTabIndex = 1;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center
                      ,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            ImageAssests.bellIcon,
                            height: 22.0,
                            color: _currentTabIndex == 2 ? blackColor : textColor,
                          ),
                          onPressed: () {
                            count=0;
                            if (_currentTabIndex == 2) {
                              return;
                            }
                            setState(() {
                              _currentTabIndex = 2;
                            });
                          },
                        ),
                        Positioned(
                          right: 31.0,
                          top: 3.0,
                          child: Visibility(
                            visible: count!=null && count!=0,
                            child: Container(
                              width: 35.0,
                              decoration: BoxDecoration(
                                  color: blackColor,
                                  shape: BoxShape.circle
                              ),
                              padding: EdgeInsets.all(5.0),
                              child: CustomtextFields.textFields(
                                  text: count!=null?count>10?"10+":count.toString():"",
                                  textColor: white_color,
                                  fontFamily: "JosefinSans",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  textAlign: TextAlign.center,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ):SizedBox(),
        ),
      ),
    );
  }

  Widget navigateToScreen(int currentTabIndex) {
    switch (currentTabIndex) {
      case 0:
        return MyDelieveriesScreen();
        break;
      case 1:
        return HomeMapScreen();
        break;
      case 2:
        return NotificationTabScreen(
          notificationScreenState: notificationTabScreenState,
        );
        break;
      case 3:
        return WhatsAppScreen();
        break;
      default:
        return MyDelieveriesScreen();
    }
  }

  void initFirebaseService() {
    firebaseMessaging.getToken().then((value) {
      myPrintTag("token", value);
    });
    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions();
    }
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        updateCount();
        myPrintTag("new notification", message);
        showNotification(message: message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        redirectToNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onMessage>>> $message");
        redirectToNotification(message);
      },
    );
  }

  void showNotification({@required Map<String, dynamic> message}) {
    showSimpleNotification(
      GestureDetector(
        onTap: () {
          redirectToNotification(message);
        },
        child: Container(
          decoration: BoxDecoration(
              color: white_color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.0),
                bottomRight: Radius.circular(2.0),
              )),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Platform.isIOS
                      ? Image.asset(
                          message["type"] == "Order picked up"
                              ? ImageAssests.deliverdNoti
                              : message["type"] == "order_create" || message["type"] == "order_status"
                                  ? ImageAssests.createOrderNoti
                                  : message["type"] == "new_feedback"
                                      ? ImageAssests.feedBackNoti
                                      : ImageAssests.deliverdNoti,
                          height: 17.0,
                          width: 17.0,
                          color: blueColor,
                        )
                      : Image.asset(
                          message["data"]["type"] == "Order picked up"
                              ? ImageAssests.deliverdNoti
                              : message["type"] == "order_create" || message["type"] == "order_status"
                                  ? ImageAssests.createOrderNoti
                                  : message["type"] == "new_feedback"
                                      ? ImageAssests.feedBackNoti
                                      : ImageAssests.deliverdNoti,
                          height: 17.0,
                          width: 17.0,
                          color: blueColor,
                        ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: CustomtextFields.textFields(
                      text: Platform.isIOS
                          ? message["title"]
                          : message["data"]["title"],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      textColor: blackColor,
                      textOverflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 3.0, left: 32.0),
                child: CustomtextFields.textFields(
                    text: Platform.isIOS
                        ? message["message"]
                        : message["data"]["message"],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    textColor: textColor,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    maxLines: 5),
              ),
            ],
          ),
        ),
      ),
      slideDismiss: true,
      background: white_color,
    );
    if (notificationTabScreenState != null) {
      notificationTabScreenState.currentState.newReceivedNotification();
    }
  }

  redirectToNotification(Map<String, dynamic> message) {
    if (Platform.isIOS) {
      if (message["type"] == "new_feedback") {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => MyRatingsScreen()));
      } else {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OrderInfoScreen(
                      id: message["order_id"],
                    )));
      }
    } else {
      if (message["data"]["type"] == "new_feedback") {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => MyRatingsScreen()));
      } else {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OrderInfoScreen(
                      id: message["data"]["order_id"],
                    )));
      }
    }
  }

  void updateCount() {
    print("tab $_currentTabIndex");
    if(_currentTabIndex!=2){
      print(count);
      if(count!=null){
        count++;
        print(count);
        setState(() {

        });
      }
    }
  }

  void getNotificationCount() async{
    Map<String,dynamic> param = Map();
    param["user_id"]= userDataModel.userId;
    Response response = await NetworkCall().callPostApi(param,ApiConstants.notificationCount);
    Map<String,dynamic> data = json.decode(response.body);
    count = int.parse(data["data"]);
    setState(() {

    });
  }

}
