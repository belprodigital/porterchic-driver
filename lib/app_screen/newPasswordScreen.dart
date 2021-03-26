import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/loginScreen.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'otpVerificationScreen.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';

class NewPasswordScreen extends StatefulWidget {

  final String userId;
  final String accessToken;
  NewPasswordScreen({this.userId,this.accessToken});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();

  bool isButtonEnable = false;
  var showLoader = false;
  bool isPasswordShow = true;
  bool isPassErrorShow = false;
  String errorPassText = requireField;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white_color,
            title: CustomtextFields.textFields(
              text: newPassword,
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
                color: blackColor,
                size: 18.0,
              ),
            ),
          ),
          body: Container(
            color: white_color,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: grey_color,
                        ),
                        child: Container(),
                      ),
                    ),
                   /* CustomtextFields.textFields(
                        fontSize: 15.0,
                        text: introText,
                        textColor: textColor,
                        maxLines: 2
                    ),
                    SizedBox(
                      height: 20.0,
                    ),*/
                    Stack(
                      children: <Widget>[
                        CustomtextFields.textFromFields(
                            fontSize: 15.0,
                            hintText: password,
                            labelText: password,
                            focusNode: _passwordFocusNode,
                            hintColor: text_color.withOpacity(0.2),
                            obsecureText: isPasswordShow,
                            context: context,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            textEditingController: _passwordController,
                            borderColor: isPassErrorShow ? redColor : textColor,
                            validator: (value) {
                              if (_passwordController.text
                                  .trim()
                                  .length > 0) {
                                setState(() {
                                  isButtonEnable = true;
                                  isPassErrorShow = false;
                                });
                              } else {
                                setState(() {
                                  isButtonEnable = false;
                                });
                              }
                            }
                        ),
                        Visibility(
                          visible: _passwordController.text.isNotEmpty,
                          child: Container(
                              margin: EdgeInsets.only(top: 12.0, right: 10.0),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPasswordShow = !isPasswordShow;
                                  });
                                },
                                child: Image.asset(
                                  ImageAssests.passwordShow, height: 20, width: 20,),
                              )
                          ),
                        ),
                        Visibility(
                          visible: isPassErrorShow,
                          child: Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(right: 10.0),
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text(errorPassText, style: TextStyle(
                                    color: redColor, fontSize: 12.0),),
                              )
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          CommonMethod.hideKeyboard(context);
                          if (isButtonEnable) {
                            if (_isValid()) {
                              //_navigateToOtpScreen();
                              callResetPassword();
                            }
                          }
                        },
                        child: isButtonEnable? Image.asset(
                          ImageAssests.disableNext, height: 18.0,width: 55.0,) : Image.asset(
                          ImageAssests.enableNext, height: 18.0,width: 55.0,),
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

  bool _isValid() {
    if (_passwordController.text
        .trim()
        .isEmpty) {
      //Fluttertoast.showToast(msg: passwordEmpty);
      setState(() {
        errorPassText = requireField;
        isPassErrorShow = true;
        _passwordFocusNode.hasFocus;
      });
      return false;
    } else if (_passwordController.text
        .trim()
        .length < 6) {
      // Fluttertoast.showToast(msg: passwordValid);
      setState(() {
        errorPassText = "Invalid password";
        isPassErrorShow = true;
        _passwordFocusNode.hasFocus;
      });
      return false;
    } else {
      return true;
    }
  }

  void _navigateToOtpVerificationScreen() {
    Navigator.push(context, CupertinoPageRoute(
        builder: (context) => OtpVerificationScreen()
    ));
  }

  void callResetPassword() async {
    if(await CommonMethod.isInternetOn()){
      setState(() {
        showLoader=true;
      });
      Map<String, dynamic> param = Map();
      param["user_id"] = widget.userId;
      param["password"] = _passwordController.text.trim();
      Response response = await NetworkCall().callPostApi(
          param, ApiConstants.resetPassword,accessToken: widget.accessToken);
      setState(() {
        showLoader=false;
      });
      Map<String, dynamic> data = json.decode(response.body);
      Fluttertoast.showToast(msg: data["message"]);
      if (data["status"]) {
        navigateToLoginScreen();
      }
    }else{
      globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
    }

  }

  void navigateToLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      ModalRoute.withName('/'),
    );
  }
}
