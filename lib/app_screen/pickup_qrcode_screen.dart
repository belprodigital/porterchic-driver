import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/camera_screen.dart';
import 'package:porterchic_driver/app_screen/whatsapp_screen.dart';
import 'package:porterchic_driver/common/dividerContainer.dart';
import 'package:porterchic_driver/icons/app_bar_icon_icons.dart';
import 'package:porterchic_driver/model/order_details_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PickUpQrScreen extends StatefulWidget {

  final String sId;
  PickUpQrScreen({this.sId});

  @override
  _PickUpQrScreenState createState() => _PickUpQrScreenState();
}

class _PickUpQrScreenState extends State<PickUpQrScreen> {

  var otpExpireTime="00:60";
  Timer timer;
  Timer otpVerifyTimer;
  String otpButtonText = sendCodeBySms;

  @override
  void initState() {
    startTimer();
    startOtpVerifyTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: white_color,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white_color,
            title: CustomtextFields.textFields(
              text: pickUpQr,
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w600,
              textColor: blackColor,
              fontSize: 25.0,
            ),
            centerTitle: false,
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                AppBarIcon.union,
                size: 15.0,
                color: blackColor,
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(left: 20.0,right: 20.0),
              child: Column(
                children: <Widget>[
                  Divider(
                    thickness: 2.0,
                    color: divider_Color,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomtextFields.textFields(
                        fontSize: 13.0,
                        fontFamily: 'JosefinSans',

                        text:extendTimes,
                        fontWeight: FontWeight.w400,
                        textColor: textColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: CustomtextFields.textFields(
                          fontSize: 15.0,
                          fontFamily: 'JosefinSans',

                          text:otpExpireTime,
                          fontWeight: FontWeight.w400,
                          textColor: textColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0,bottom: 16.0),
                    child: QrImage(
                      data: widget.sId,
                      version: QrVersions.auto,
                      size: 290.0,
                    ),
                  ),
                  CustomtextFields.textFields(
                    fontSize: 17.0,
                    text:qrDescription,
                    fontFamily: 'JosefinSans',

                    maxLines: 3,
                    fontWeight: FontWeight.w400,
                    textColor: textColor,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  /*DividerContainer.divider(
                    text: havingProblems.toUpperCase(),
                    context: context,
                    textColor: textColor,
                    dividerColor: textColor
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: CustomButtons.loginButton(
                        backgroundColor: buttonColor,
                        fontFamily: 'JosefinSans',
                        fontSize: 16.0,
                        text: otpButtonText,
                        textColor: white_color,
                        function: (){
                          setState(() {
                            otpButtonText=resendOtp;
                          });
                          callSendCodeBySms();
//                          navigateToCameraScreen();
                        },
                        radiusSize: 0.0
                    ),
                  ),
                  SizedBox(height: 26.0,),*/
                  GestureDetector(
                    onTap: () async{
                      if(await canLaunch(launchWhatsApp(phone: whatsAppNum))){
                      await launch(launchWhatsApp(phone: whatsAppNum));
                      }else{
                      Fluttertoast.showToast(msg: msg_install_whatsapp);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(ImageAssests.supportIcon,height: 24.0,width: 24.0,),
                        SizedBox(width: 8.0,),
                        CustomtextFields.textFields(
                          fontSize: 17.0,
                          text:contactSupport,
                          fontFamily: 'JosefinSans',

                          fontWeight: FontWeight.w700,
                          textColor: textColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(timer.tick<60){
        setState(() {
          int time = 60-timer.tick;
          if(time<10){
            otpExpireTime = "00:0"+time.toString();
          }else{
            otpExpireTime = "00:"+time.toString();
          }
        });
      }else{
        setState(() {
          otpExpireTime="00:00";
//          isResendOtp=true;
        });
        timer.cancel();
      }
      print(timer.tick);
    });
  }



  @override
  void dispose() {
    if(timer!=null){
      timer.cancel();
      otpVerifyTimer.cancel();
    }
    super.dispose();
  }

  void navigateToCameraScreen() {
        Navigator.push(context, CupertinoPageRoute(
          builder: (context)=>CameraScreen(orderId: widget.sId,isFromDelivery: false,)
        ));
  }

  Future callSendCodeBySms() async{
    Map<String,dynamic> param = Map();
    param["order_id"] = widget.sId;
    NetworkCall().callPostApi(param, ApiConstants.driverPickupOtp);
  }

  void startOtpVerifyTimer() {
    otpVerifyTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      callOrderDetailsApi();
    });
  }

  Future<void> callOrderDetailsApi() async {
    Map<String, dynamic> param = Map();
    param["order_id"] = widget.sId;
    Response response =
        await NetworkCall().callPostApi(param, ApiConstants.orderDetails);
    Map<String, dynamic> data = json.decode(response.body);
    OrderDetailsModel orderDetailsModel = OrderDetailsModel.fromJson(data);
    if (orderDetailsModel.status) {
          if(orderDetailsModel.data.order.otpVerify!=null && orderDetailsModel.data.order.otpVerify==1){
            navigateToCameraScreen();
            otpVerifyTimer.cancel();
            timer.cancel();
          }
    }
  }

  String launchWhatsApp({@required String phone}) {
    try{
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse("")}";
      } else {
        return "whatsapp://send?phone=$phone}";
      }
    }
    catch(e){
      myPrintTag("error", e.toString());
    }
  }

}
