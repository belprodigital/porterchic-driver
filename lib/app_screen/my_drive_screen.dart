import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MydriveScreen extends StatefulWidget {
  @override
  _MyDriveScreenState createState() => _MyDriveScreenState();
}

class _MyDriveScreenState extends State<MydriveScreen> {

  String totalOrder="",totalMileageText="",finishedOrder="",mileageText="";
  int daysOnRoadText=0;
  bool showLoader=false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  void initState() {
    getMyDriveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          key: globalKey,
          backgroundColor: white_color,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white_color,
            title: CustomtextFields.textFields(
              text: myDrives,
              fontWeight: FontWeight.w500,
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
          body: getMainWidget(),
        ),
      ),
    );
  }

  Widget getOrderMileageCard({@required String image , @required title , @required String subTitle}) {
    return Expanded(
      child: Card(
        color: white_color,
        elevation: 5.0,
        shadowColor: cardShadowColor,
        child: Container(
          margin: EdgeInsets.all(18.0),
          child: Row(
            children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15.0),
                child: Image.asset(image,height: 36.0,width: 36.0,)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomtextFields.textFields(
                    text: title,
                    textColor: textColor,
                    fontSize: 12.0,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                  RichText(
                    text: TextSpan(
                      children:<TextSpan>[
                        TextSpan(
                          text: subTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                            color: blackColor
                          )
                        ),
                        TextSpan(
                          text: title==totalMileage?" km":"",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            fontFamily: "Mada",
                            color: blackColor
                          )
                        )
                      ]
                    ),
                  )
                ],
              ),
            )
            ],
          ),
        ),
      ),
    );
  }

  Widget getOrderDetailsWidget({@required String title,@required String subTitle}) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12.0,bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomtextFields.textFields(
                text: title,
                textColor: textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              CustomtextFields.textFields(
                text: subTitle,
                textColor: blackColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  void getMyDriveData() async{
    if(await CommonMethod.isInternetOn()){
      setState(() {
        showLoader=true;
      });
      Map<String,dynamic> param = Map();
      Response response = await NetworkCall().callPostApi(param, ApiConstants.drivesData);
      Map<String,dynamic> data = json.decode(response.body);
      if(data["status"]){
        totalOrder = data["data"]["total_order"];
        totalMileageText = data["data"]["total_mileage"];
        finishedOrder = data["data"]["finished_order"];
        mileageText = data["data"]["mileage"];
        daysOnRoadText = data["data"]["days_on_road"];
        setState(() {
          showLoader=false;
        });
      }
    }else{
      globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
    }

  }

  Widget getMainWidget() {
    if(showLoader){
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
        ),
      );
    }else{
      return  SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0,right: 20.0),
          child: Column(
            children: [
              Row(children: <Widget>[
                getOrderMileageCard(image: ImageAssests.totalOrder, title: totalOrders, subTitle: totalOrder),
                getOrderMileageCard(image: ImageAssests.totalMileage, title: totalMileage, subTitle: totalMileageText),
              ],
              ),
              SizedBox(height: 25.0,),
              getOrderDetailsWidget(title: finishedOrders, subTitle: finishedOrder),
              getOrderDetailsWidget(title: mileage, subTitle: mileageText),
              getOrderDetailsWidget(title: daysOnRoad, subTitle: daysOnRoadText.toString()+"/"+DateTime.now().day.toString()),
//              getOrderDetailsWidget(title: income, subTitle: "8/12")
            ],
          ),
        ),
      );
    }
  }

}
