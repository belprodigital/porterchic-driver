import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/otpVerificationScreen.dart';
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

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController _phoneNumberController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();

  bool isButtonEnable = false;
  var showLoader = false;
  bool isPhoneErrorShow = false;
  String errorPhoneText = requireField;
  //Country selectedCountry = Country.AE;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          key: globalKey,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white_color,
            title: CustomtextFields.textFields(
              text: forgot_password,
              fontFamily: 'JosefinSans',

              fontWeight: FontWeight.w600,

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
                size: 15.0,
                color: blackColor,
              ),
            ),
          ),
          body: Container(
            color: white_color,
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Stack(
              children: <Widget>[
                Column(
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
                        fontSize: 15.0,
                        text:introText,
                        textColor: textColor,
                        maxLines: 2
                    ),
                    SizedBox(
                      height: 30.0,
                    ),*/
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0,top: 7.0),
                          child: CustomtextFields.textFromFields(
                            fontSize: 16.0,
                            hintText: hint_phone_number,
                            labelText: "",
                            focusNode: _phoneFocusNode,
                            hintColor: textColor.withOpacity(0.2),
                            obsecureText: false,
                            context: context,
                            leftPadding: 50.0,
                            maxLength: 15,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            textEditingController: _phoneNumberController,
                            nextFocusNode: FocusNode(),
                            borderColor: isPhoneErrorShow?redColor:textColor,
                            validator:(value){
                              if(_phoneNumberController.text.trim().length>0 /*&& _passwordController.text.trim().length>0*/){
                                setState(() {
                                  isButtonEnable = true;
                                  isPhoneErrorShow = false;
                                });
                              }else{
                                setState(() {
                                  isButtonEnable = false;
                                });
                              }
                            },
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   width: 50.0,
                        //   margin: EdgeInsets.only(left: 5.0,right: 5.0),
                        //   child: CountryPicker(
                        //     selectedCountry: selectedCountry,
                        //     showFlag: false,
                        //     showName: false,
                        //     showDialingCode: true,
                        //     onChanged: (Country value) {
                        //       setState(() {
                        //         selectedCountry = value;
                        //       });

                        //     },

                        //     dialingCodeTextStyle: TextStyle(
                        //       color: blackColor,
                        //       fontSize: 16.0,
                        //       fontFamily: "JosefinSans",
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        // ),
                        CustomtextFields.labelTextWidget(labelText: "Phone number"),
                        Visibility(
                          visible: isPhoneErrorShow,
                          child: Positioned(
                              bottom:0.0,
                              right: 0.0,
                              child:Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(right:10.0),
                                padding: EdgeInsets.only(left:10.0,right:10.0),
                                child: Text(errorPhoneText,style:TextStyle(color:redColor,fontSize:12.0),),
                              )
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      alignment:Alignment.centerRight,
                      child:GestureDetector(
                        onTap: () async {
                          CommonMethod.hideKeyboard(context);
                          if(isButtonEnable){
                            if(_isValid()){
                              if(await CommonMethod.isInternetOn()){
                                setState(() {
                                  showLoader=true;
                                });
                                callForgoPasswordApi();
                              }else{
                                globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
                              }
                            }
                          }
                        },
                        child:isButtonEnable == true?Image.asset(ImageAssests.disableNext,height:55.0,width: 55.0,):Image.asset(ImageAssests.enableNext,height:55.0,width: 55.0,),
                      ),
                    )
                    /* CustomButtons.loginButton(
                      fontSize: 15.0,
                      textColor: white_color,
                      backgroundColor: text_color,
                      text: continue_text,
                      function: () {
                        if (_isValid()) {

                        }
                      }
                  ),*/
                  ],
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
      ),
    );
  }

  Widget textFields(String labelText) {
    return CustomtextFields.textFields(
      text: labelText,
      textColor: text_color,
      fontSize: 13.0,
    );
  }

  void _navigateToOtpScreen({String userId,String accessToken}) {
      Navigator.push(context,
        CupertinoPageRoute(builder: (context) => OtpVerificationScreen(userId: userId,isFromDelivery: false,accessToken: accessToken,)));

    /*Navigator.push(context,
        CupertinoPageRoute(builder: (context) => ForgotPasswordScreen()));*/
  }
  bool _isValid() {

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    String phNo = _phoneNumberController.text.trim();
    if(phNo.isEmpty){
      setState(() {
        errorPhoneText = requireField;
        isPhoneErrorShow = true;
        _phoneFocusNode.hasFocus;

      });
      //Fluttertoast.showToast(msg:phNoEmpty);
      return false;
    }else if(_phoneNumberController.text.trim().length < 6 ||
        _phoneNumberController.text.trim().length > 15){
      //Fluttertoast.showToast(msg:phNoValid);
      setState(() {
        errorPhoneText = "Invalid Phone number";
        isPhoneErrorShow = true;
        _phoneFocusNode.hasFocus;

      });
      return false;
    }else{
      return true;
    }
  }
  Future callForgoPasswordApi() async{
    Map<String,dynamic> params = Map();
    //params["mobile"]="+"+selectedCountry.dialingCode+_phoneNumberController.text.trim();
    params["mobile"]="+";
    Response response = await NetworkCall().callPostApi(params, ApiConstants.forgotPassword);
    setState(() {
      showLoader=false;
    });
    Map<String,dynamic> data = jsonDecode(response.body);
    Fluttertoast.showToast(msg:data["message"] );
    if(data["status"]){
      _navigateToOtpScreen(userId:data["data"]["user_id"],accessToken: data["data"]["accessToken"]);
    }
  }
}
