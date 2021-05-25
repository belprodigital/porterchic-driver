import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/my_drive_screen.dart';
import 'package:porterchic_driver/app_screen/myratings_screen.dart';
import 'package:porterchic_driver/app_screen/personal_information.dart';
import 'package:porterchic_driver/app_screen/previewsScreen.dart';
import 'package:porterchic_driver/app_screen/setting.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/model/personalinfo.dart';
import 'package:porterchic_driver/model/user_data_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/custom_widgets.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  SharedPreferences sharedPreferences;
  UserDataModel userDataModel;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPreferences){
      this.sharedPreferences = sharedPreferences;
      getProfile();
      getProfileData();
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
            text: profileLabel,
            fontFamily: 'JosefinSans',

            textColor: blackColor,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  userDataModel!=null && userDataModel.profilePic!=null && userDataModel.profilePic.isNotEmpty?CustomWidgets.getPhotos(productImage: userDataModel.profilePic,height: 100.0,width: 100.0,boxShape: BoxShape.circle):Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: divider_Color,
                          shape: BoxShape.circle
                        ),
                      ),
                      Center(child: Image.asset(ImageAssests.userProfile,height: 40.0,width:40.0,color: textColor,)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: CustomtextFields.textFields(
                      text: userDataModel!=null?userDataModel.firstName+" "+userDataModel.lastName:"",
                      textColor: blackColor,
                      fontFamily: 'JosefinSans',

                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RatingBar(
                        ignoreGestures: true,
                        glow: false,
                        initialRating: userDataModel!=null && userDataModel.rating!=null?double.parse(userDataModel.rating):0,
                        itemCount: 5,
                        allowHalfRating: true,
                        itemSize: 14.0,
                        itemPadding: EdgeInsets.only(right: 5.0),
                        ratingWidget: RatingWidget(
                            half: Image.asset(ImageAssests.halfRating,),
                            full: Image.asset(ImageAssests.fullRating,),
                            empty: Image.asset(ImageAssests.emptyRating,)

                        ),
                        onRatingUpdate: (double value) {  },

                      ),
                      CustomtextFields.textFields(
                        text: userDataModel!=null && userDataModel.rating!=null?userDataModel.rating+"/5":"0/5",
                        textColor: blackColor,
                        fontSize: 12,
                          fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.w600
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: personalinformation.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    child: profile(index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              navigateToOtherScreen(index, context),
                        ),
                      ).then((value){
                        if(index==0){
                          getProfileData();
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget profile(int index) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 45,
              height: 45,
              child: Container(
                child: personalinformation[index].symbol,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomtextFields.textFields(
                    text: personalinformation[index].title,
                    fontSize: 16.0,
                    fontFamily: "JosefinSans",
                    textColor: blackColor,
                    maxLines: 1,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  CustomtextFields.textFields(
                    text: personalinformation[index].subtitle,
                    fontSize: 12.0,
                    fontFamily: "JosefinSans",
                    textColor: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getProfileData() async{
    Map<String,dynamic> data = json.decode(sharedPreferences.getString(ApiConstants.userData));
    userDataModel = UserDataModel.fromJson(data);
    // print(userDataModel.rating);
    setState(() {

    });

  }

  void getProfile() async{
    Map<String,dynamic> param = Map();
    Response response = await NetworkCall().callPostApi(param,ApiConstants.getProfile);
    Map<String,dynamic> data = json.decode(response.body);
    if(data["status"]){
      SharedPreferences.getInstance().then((sharedPref){
        sharedPref.setString(ApiConstants.userData,json.encode(data["data"]));
        getProfileData();
        sharedPref.setBool(ApiConstants.newOrder,data["data"]["assign_order"]==1?true:false);
        sharedPref.setBool(ApiConstants.orderStatus,data["data"]["order_status"]==1?true:false);
        sharedPref.setBool(ApiConstants.feedBack,data["data"]["new_feedback"]==1?true:false);
        if(data["data"]["status"]==2){
          sharedPref.clear();
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => PreviewScreen()),
              (route) => false);
          Fluttertoast.showToast(
              msg:
                  "Your account is deactivated by admin. Please contact support team");
        }
      });
    }

  }

  Widget navigateToOtherScreen(int index, context) {
    if (index == 0) {
      return PersonalInformationScreen(userDataModel: userDataModel,);
    } else if (index == 1) {
    return MyRatingsScreen();
  } else if (index == 2) {
    return MydriveScreen();
  } else if (index == 3) {
      return SettingsScreen();
    }
  }
}




