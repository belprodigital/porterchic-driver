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

class ChangePasswordScreen extends StatefulWidget {
  final String texts;

  // receive data from the FirstScreen as a parameter
  ChangePasswordScreen({Key key, @required this.texts}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState(texts);
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  TextEditingController _confirmPasswordController = TextEditingController();
  FocusNode _confirmPFocusNode = FocusNode();
  bool showLoader= false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  bool isButtonEnable = false;
  bool isConfirmPasswordVisible = false;
  bool isPasswordShow = true;
  bool isPassErrorShow = false;
  bool isConfirmPasswordShow = true;
  bool isConfirmPassErrorShow = false;
  String errorPassText = requireField;
  final String texts;


  _ChangePasswordScreenState(this.texts);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
        backgroundColor: white_color,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white_color,
          title: CustomtextFields.textFields(
            text: texts ?? ' ',
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
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              reverse: true,
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      width: 120.0,
                      margin: EdgeInsets.only(top: 25.0,bottom: 20.0,),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: grey_color
                          /* image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black54, BlendMode.multiply),
                              image: AssetImage('images/Image 1.png'),
                              fit: BoxFit.cover,
                            )*/
                          ),
                    ),
                   /* Container(
                      margin: EdgeInsets.only(bottom: 32.0, top: 20.0),
                      child: CustomtextFields.textFields(
                          fontSize: 16.0,
                           text:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum bibendum velit in nunc pulvinar vehicula.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum bibendum velit in nunc pulvinar vehicula.",
                          textColor: textColor,
                           textAlign: TextAlign.center,
                          maxLines: 2),
                    ),*/
                    Stack(
                      children: <Widget>[
                        Container(
                          margin:EdgeInsets.only(bottom:5.0),
                          child: CustomtextFields.textFromFields(
                            fontSize: 15.0,
                            hintText: isConfirmPasswordVisible?newPassword:oldPassword,
                            labelText: isConfirmPasswordVisible?newPassword:oldPassword,
                            obsecureText: isPasswordShow,
                            focusNode: _passwordFocusNode,
                            hintColor: textColor.withOpacity(0.4),
                            context: context,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            textEditingController: _passwordController,
                            nextFocusNode: _confirmPFocusNode,
                            borderColor:  isPassErrorShow?redColor:textColor,
                            validator:(value){
                              if(_passwordController.text.trim().length>0){
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
                        Visibility(
                          visible: _passwordController.text.isNotEmpty  ,
                          child: Container(
                              margin: EdgeInsets.only(top:12.0,right:10.0),
                              alignment: Alignment.centerRight,
                              child:GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isPasswordShow = !isPasswordShow;
                                  });
                                },
                                child: Image.asset(isPasswordShow?ImageAssests.passwordShow:ImageAssests.hidePassword,height:20,width:20,),
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
                      height: 22.0,
                    ),
                    Visibility(
                      visible: isConfirmPasswordVisible,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin:EdgeInsets.only(bottom:5.0),
                            child: CustomtextFields.textFromFields(
                              fontSize: 15.0,
                              hintText: confirmPassword ,
                              labelText: confirmPassword,
                              obsecureText: isConfirmPasswordShow,
                              focusNode: _confirmPFocusNode,
                              hintColor: textColor.withOpacity(0.4),
                              context: context,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              textEditingController: _confirmPasswordController,
                              nextFocusNode: FocusNode(),
                              borderColor:  isConfirmPassErrorShow?redColor:textColor,
                              validator:(value){
                                if(_confirmPasswordController.text.trim().length>0){
                                  setState(() {
                                    isButtonEnable = true;
                                    isConfirmPassErrorShow = false;
                                  });
                                }else{
                                  setState(() {
                                    isButtonEnable = false;
                                  });
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: _confirmPasswordController.text.isNotEmpty,
                            child: Container(
                                margin: EdgeInsets.only(top:12.0,right:10.0),
                                alignment: Alignment.centerRight,
                                child:GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isConfirmPasswordShow = !isConfirmPasswordShow;
                                    });
                                  },
                                  child: Image.asset(isConfirmPasswordShow?ImageAssests.passwordShow:ImageAssests.hidePassword,height:20,width:20,),
                                )
                            ),
                          ),
                          Visibility(
                            visible: isConfirmPassErrorShow,
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
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          child: Container(
                              child:isButtonEnable == true?Image.asset(ImageAssests.disableNext,height:18.0,width: 55.0,):Image.asset(ImageAssests.enableNext,height:18.0,width: 55.0,)

                          ),
                          onTap: () async{
                            CommonMethod.hideKeyboard(context);
                            if(isValid()){
                              if(await CommonMethod.isInternetOn()){
                                callCheckPasswordApi(context);
                              }else{
                                globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
                              }
                            }
                          }),
                    )
                  ],
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
        );
  }

  bool isValid() {
    if(_passwordController.text.trim().isEmpty){
      setState(() {
        isPassErrorShow = true;
        errorPassText = requireField;
        _passwordFocusNode.hasFocus;
      });
      return false;
    }else if(_passwordController.text.trim().length<6){
      setState(() {
        isPassErrorShow = true;
        errorPassText = invalidPassword;
        _passwordFocusNode.hasFocus;
      });
      return false;
    }else if(isConfirmPasswordVisible && _confirmPasswordController.text.trim().isEmpty){
      setState(() {
        isConfirmPassErrorShow = true;
        errorPassText = requireField;
        _confirmPFocusNode.hasFocus;
      });
      return false;
    }else if(isConfirmPasswordVisible && _confirmPasswordController.text.trim().length<6){
      setState(() {
        isConfirmPassErrorShow = true;
        errorPassText = invalidPassword;
        _confirmPFocusNode.hasFocus;
      });
      return false;
    }else if(isConfirmPasswordVisible && _confirmPasswordController.text.trim()!=_passwordController.text.trim()){
      globalKey.currentState.showSnackBar(SnackBar(content: Text(passwordNotMatch),));
      return false;
    }
    return true;
  }

  void callCheckPasswordApi(BuildContext context) async{
    setState(() {
      showLoader=true;
    });
    Map<String,dynamic> param = Map();
    param["password"] = _passwordController.text.trim();
    Response response = await NetworkCall().callPostApi(param, isConfirmPasswordVisible?ApiConstants.resetPassword:ApiConstants.checkPassword);
    Map<String,dynamic> data = json.decode(response.body);
    setState(() {
      showLoader=false;
    });
    if(data["status"]){
      if(isConfirmPasswordVisible){
        globalKey.currentState.showSnackBar(SnackBar(content: Text(data["message"]),duration: Duration(seconds: 1),));
        Future.delayed(Duration(seconds: 1),(){
          Navigator.pop(context);
        });
      }else{
        _passwordController.clear();
        setState(() {
          isConfirmPasswordVisible = true;
          isPasswordShow = true;
          isPassErrorShow = false;
        });
      }
    }else{
      globalKey.currentState.showSnackBar(SnackBar(content: Text(data["message"]),));
    }

  }

}
