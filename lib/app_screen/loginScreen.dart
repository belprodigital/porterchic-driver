import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/forgotpasswordScreen.dart';
import 'package:porterchic_driver/app_screen/homeScreen.dart';
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
import 'myDelieveriesScreen.dart';
import 'otpVerificationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  SharedPreferences _sharedPreferences;
  var showLoader = false;
  bool isButtonEnable = false;
  bool isPasswordShow = true;
  bool isPhoneErrorShow = false;
  bool isPassErrorShow = false;
  String errorPhoneText = "This is required field";
  String errorPassText = "This is required field";
  String deviceToken;
  var firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  Country selectedCountry = Country.AE;

  @override
  void initState() {
    SharedPreferences.getInstance().then((_sharedPreferences) {
      this._sharedPreferences=_sharedPreferences;
    });
    firebaseMessaging.getToken().then((deviceToken){
      this.deviceToken = deviceToken;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          key: _globalKey,
          backgroundColor: white_color,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white_color,
            title: CustomtextFields.textFields(
              text: login,
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
          body: Stack(
            children: <Widget>[
              IgnorePointer(
                ignoring: showLoader,
                child: Container(
                  color: white_color,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20.0,right: 20.0,top:20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*CustomtextFields.textFields(
                            fontSize: 15.0,
                            text:introText,
                            textAlign: TextAlign.center,
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
                                  nextFocusNode: _passwordFocusNode,
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
                            Container(
                              alignment: Alignment.center,
                              width: 50.0,
                              margin: EdgeInsets.only(left: 5.0,right: 5.0),
                              child: CountryPicker(
                                selectedCountry: selectedCountry,
                                showFlag: false,
                                showName: false,
                                showDialingCode: true,
                                onChanged: (Country value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });

                                },

                                dialingCodeTextStyle: TextStyle(
                                  color: blackColor,
                                  fontSize: 16.0,
                                  fontFamily: "JosefinSans",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
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
                          height: 25.0,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top:7.0,bottom: 5.0),
                              child: CustomtextFields.textFromFields(
                                fontSize: 15.0,
//                              hintText: hint_phone_number,
                                labelText: "",
                                hintText: "Password",
                                obsecureText: isPasswordShow,
                                focusNode: _passwordFocusNode,
                                hintColor: textColor.withOpacity(0.2),
                                context: context,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                textEditingController: _passwordController,
                                nextFocusNode: FocusNode(),
                                borderColor:  isPassErrorShow?redColor:textColor,
                                validator:(value){
                                if(/*_phoneNumberController.text.trim().length>0 && */_passwordController.text.trim().length>0){
                                  setState(() {
                                    isButtonEnable = true;
                                    isPassErrorShow = false;
                                  });
                                }else{
                                  setState(() {
                                    isButtonEnable = false;
                                  });
                                }
                              },
                              ),
                            ),
                            CustomtextFields.labelTextWidget(labelText: "Password"),
                            Visibility(
                              visible: _passwordController.text.isNotEmpty,
                              child: Container(
                                margin: EdgeInsets.only(right:10.0),
                                alignment: Alignment.centerRight,
                                child:GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isPasswordShow = !isPasswordShow;
                                    });
                                  },
                                  child: Image.asset(isPasswordShow?ImageAssests.passwordShow:ImageAssests.hidePassword,height:20,width:20,)
                                )
                              ),
                            ),
                            Visibility(
                              visible: isPassErrorShow,
                              child: Positioned(
                                  bottom:0.0,
                                  right: 0.0,
                                  child:Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.only(right:10.0),
                                    padding: EdgeInsets.only(left:10.0,right:10.0),
                                    child: Text(errorPassText,style:TextStyle(color:redColor,fontSize:12.0),),
                                  )
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomtextFields.textFields(
                              fontSize: 16.0,
                              text: forgotPassword,
                              textColor: textColor,
                            ),
                            SizedBox(
                              width:2.0,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) => ForgotPasswordScreen()));
                              },
                              child: CustomtextFields.textFields(
                                  fontSize: 16.0,
                                  text: recover,
                                  textColor: buttonColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
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
                                if(isValid()){
                                  if(await CommonMethod.isInternetOn()){
                                    setState(() {
                                      showLoader=true;
                                    });
                                    callLoginApi();
                                  }else{
                                    _globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
                                  }
                                }
                              }
                            },
                            child:isButtonEnable == true?Image.asset(ImageAssests.disableNext,height:18.0,width: 55.0,):Image.asset(ImageAssests.enableNext,height:18.0,width: 55.0,),
                          ),
                        )
                        /*CustomButtons.loginButton(
                            fontSize: 15.0,
                            textColor: white_color,
                            backgroundColor: text_color,
                            text:continue_text,
                            function: (){
                              CommonMethod.hideKeyboard(context);
                              if(isValid()){
                                setState(() {
                                  showLoader=true;
                                });
                                callLoginApi();
                              }
                            }
                        )*/
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
    if(_phoneNumberController.text.trim().isEmpty){
      setState(() {
          errorPhoneText = "This is required field";
          isPhoneErrorShow = true;
          _phoneFocusNode.hasFocus;

      });
      //Fluttertoast.showToast(msg:phNoEmpty);
      return false;
    }else if(_phoneNumberController.text.trim().length < 6 ||
        _phoneNumberController.text.trim().length > 15){
      setState(() {
        errorPhoneText = "Wrong phone";
        isPhoneErrorShow = true;
        _phoneFocusNode.hasFocus;

      });
     // Fluttertoast.showToast(msg:phNoValid);
      return false;
    }else if(_passwordController.text.trim().isEmpty){
      setState(() {
        errorPassText = "Wrong Password";
        isPassErrorShow = true;
        _passwordFocusNode.hasFocus;

      });
      return false;
      //Fluttertoast.showToast(msg:passwordEmpty );
    }else if(_passwordController.text.trim().length <6){
      setState(() {
        errorPassText = "Invalid password";
        isPassErrorShow = true;
        _passwordFocusNode.hasFocus;

      });
      return false;
      //Fluttertoast.showToast(msg:passwordValid);
    }else{
      return true;
    }
  }

  void _navigateToForgotPassword({String userId}) {
  /*  Navigator.push(context,
        CupertinoPageRoute(builder: (context) => OtpVerificationScreen(userId: userId,)));*/

    Navigator.pushAndRemoveUntil(context,
        CupertinoPageRoute(builder: (context) => HomeScreen()),
        (route)=>false);
  }

  Future callLoginApi() async{
    Map<String,dynamic> params = Map();
    params["mobile"]="+"+selectedCountry.dialingCode+_phoneNumberController.text.trim();
    params["password"] = _passwordController.text.trim();
    params["device_token"]=deviceToken;

    Response response = await NetworkCall().callPostApi(params, ApiConstants.login);
    setState(() {
      showLoader=false;
    });
    Map<String,dynamic> data = jsonDecode(response.body);
    Fluttertoast.showToast(msg:data["message"] );
    if(data["status"]){
      _sharedPreferences.setString(ApiConstants.accessToken, data["data"]["accessToken"]);
      _sharedPreferences.setBool(ApiConstants.isLogin,true);
      _sharedPreferences.setBool(ApiConstants.locationOff,true);
      _sharedPreferences.setString(ApiConstants.userData,jsonEncode(data["data"]));
      _navigateToForgotPassword(userId:data["data"]["user_id"]);
    }
  }
}
