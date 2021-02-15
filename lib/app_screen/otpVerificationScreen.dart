import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:porterchic_driver/app_screen/camera_screen.dart';
import 'package:porterchic_driver/app_screen/newPasswordScreen.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String orderId;
  final String accessToken;
  final bool isFromDelivery;
  OtpVerificationScreen({this.userId,this.isFromDelivery,this.orderId,this.accessToken});
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  TextEditingController _confirmationCodeController = TextEditingController();
  FocusNode _confirmCodeFocusNode = FocusNode();

  bool isButtonEnable = false;
  var showLoader = false;
  SharedPreferences _sharedPreferences;
  var otpExpireTime="00:00";
  var isResendOtp=false;
  Timer timer;

  bool isOtpErrorShow = false;
  String errorOtpText = "This is required field";

  @override
  void initState() {
    SharedPreferences.getInstance().then((_sharedPreferences) {
      this._sharedPreferences=_sharedPreferences;
    });
      startTimer();
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
              text:confirmation_code,
              textColor: blackColor,
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
            titleSpacing: 0.0,
            centerTitle: false,
            leading: IconButton(
              onPressed: (){
                timer.cancel();
                Navigator.pop(context);
              },
              icon: Icon(
                BackIcon.union,
                color: blackColor,
                size: 18.0,
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              IgnorePointer(
                ignoring: showLoader,
                child: Container(
                  color: white_color,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0,bottom: 15.0),
                            height: 120.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: grey_color,
                            ),
                            child: Container(),
                          ),
                        ),
                        /*CustomtextFields.textFields(
                            fontSize: 12.0,
                            text:introText,
                            textColor: textColor,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.center,
                            maxLines: 2
                        ),
                        SizedBox(
                          height: 30.0,
                        ),*/
                        PinCodeTextField(
                          length: 6,
                          controller: _confirmationCodeController,
                          textInputType: TextInputType.number,
                          textStyle: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Mada",
                            fontSize: 16.0
                          ),
                          onChanged: (String value) {
                            if(_confirmationCodeController.text.trim().length == 6){
                              setState(() {
                                isButtonEnable = true;
                              });
                            }else{
                              setState(() {
                                isButtonEnable = false;
                              });

                            }
                          },
                          pinTheme: PinTheme(
                            borderWidth: 1.0,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(4.0),
                            fieldHeight: 45,
                            fieldWidth: 45,
                            activeColor: divider_Color,
                            inactiveColor: divider_Color,
                            selectedColor: divider_Color,
                          ),
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        !isResendOtp?Row(
                          mainAxisAlignment: widget.isFromDelivery?MainAxisAlignment.center:MainAxisAlignment.end,
                          children: <Widget>[
                            CustomtextFields.textFields(
                              fontSize: 13.0,
                              text:extendTimes,
                              fontWeight: FontWeight.w400,
                              textColor: textColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: CustomtextFields.textFields(
                                fontSize: 13.0,
                                text:otpExpireTime,
                                fontWeight: FontWeight.w400,
                                textColor: textColor,
                              ),
                            ),
                          ],
                        ):GestureDetector(
                          onTap: (){
                            setState(() {
                              isResendOtp=false;
                            });
                            callResendOtp();
                            Fluttertoast.showToast(msg: otp_sent);
                            startTimer();
                          },
                          child: Align(
                            alignment: !widget.isFromDelivery?Alignment.centerRight:Alignment.center,
                            child: CustomtextFields.textFields(
                              fontSize: 13.0,
                              text:resendOtp,
                              textAlign: TextAlign.end,
                              fontWeight: FontWeight.w400,
                              textColor: textColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        widget.isFromDelivery?CustomButtons.loginButton(
                            backgroundColor: buttonColor,
                            fontSize: 16.0,
                            text: continue_text,
                            textColor: white_color,
                            function: (){
                              callOtpVerify();
                            },
                            radiusSize: 0.0
                        ):Container(
                          alignment:Alignment.centerRight,
                          child:GestureDetector(
                            onTap: (){
                              CommonMethod.hideKeyboard(context);
                              if(isButtonEnable){
                                if(isValid()){
                                  setState(() {
                                    showLoader=true;
                                  });
                                 callOtpVerify();
                               }
                              }
                            },
                            child:isButtonEnable == true?Image.asset(ImageAssests.disableNext,height:55.0,width: 55.0,):Image.asset(ImageAssests.enableNext,height:55.0,width: 55.0,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showLoader,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValid() {
    if(_confirmationCodeController.text.trim().isEmpty){
      setState(() {
        errorOtpText = "This is required field";
        isOtpErrorShow = true;
        _confirmCodeFocusNode.hasFocus;

      });
      //Fluttertoast.showToast(msg: valid_otp);
      return false;
    }else if(_confirmationCodeController.text.trim().length<6){
      setState(() {
        errorOtpText = "Invalid confirmation code";
        isOtpErrorShow = true;
        _confirmCodeFocusNode.hasFocus;

      });
      //Fluttertoast.showToast(msg: valid_otp);
      return false;
    }else{
      return true;
    }
  }

  void _navigateToNewPasswordScreen() {
      Navigator.push(context, CupertinoPageRoute(
          builder: (context)=>NewPasswordScreen(userId: widget.userId,accessToken: widget.accessToken,)
      ));
  }

  Future callOtpVerify() async{
    Map<String,dynamic> param = Map();
    if(widget.isFromDelivery){
      param["order_id"]=widget.orderId;
    }else{
      param["user_id"]=widget.userId;
    }
    param["otp"]=_confirmationCodeController.text.trim();
    Response response = await NetworkCall().callPostApi(param, widget.isFromDelivery?ApiConstants.oredrVerifyOtp:ApiConstants.otpVerify,accessToken: widget.accessToken);
    setState(() {
      showLoader=false;
    });
    Map<String,dynamic> data = jsonDecode(response.body);
    Fluttertoast.showToast(msg:data["message"] );
    if(data["status"]){
      timer.cancel();
      _sharedPreferences.setString(ApiConstants.userData, jsonEncode(data["data"]));
      _sharedPreferences.setBool(ApiConstants.isLogin,true);
      if(widget.isFromDelivery){
        _navigateToCameraScreen();
      }else{
        _navigateToNewPasswordScreen();
      }
    }
  }

  void startTimer() {
   timer = Timer.periodic(Duration(seconds: 1), (timer) {
     if(!mounted){
       return;
     }
     int time=  timer.tick;
      if(time<60){
        time = 60-time;
        setState(() {
          if(time<10){
            otpExpireTime = "00:0"+time.toString();
          }else{
            otpExpireTime = "00:"+time.toString();
          }
        });
      }else{
        setState(() {
          otpExpireTime="00:00";
          isResendOtp=true;
        });
        timer.cancel();
      }
      // print(timer.tick);
    });
  }

  Future callResendOtp() async{
    Map<String,dynamic> param = Map();
    if(widget.isFromDelivery){
      param["order_id"]=widget.orderId;
    }else{
      param["user_id"]=widget.userId;
    }
    Response response = await NetworkCall().callPostApi(param, widget.isFromDelivery?ApiConstants.deliveryOtp:ApiConstants.resendOtp,accessToken: widget.accessToken);
  }

  void _navigateToCameraScreen() {
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => CameraScreen(isFromDelivery: true,orderId: widget.orderId,)
    ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
