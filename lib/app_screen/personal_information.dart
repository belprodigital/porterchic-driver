  import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/model/user_data_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/custom_widgets.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformationScreen extends StatefulWidget {

  final UserDataModel userDataModel;
  PersonalInformationScreen({this.userDataModel});

  @override
  _PersonalInformationScreenState createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  String errorPasswordText = requireField;
  bool isFirstNameErrorShow = false;
  bool isLastNameErrorShow = false;
  File croppedFile;
  bool showLoader = false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    _firstNameController.text = widget.userDataModel.firstName;
    _lastNameController.text = widget.userDataModel.lastName;
    _emailController.text = widget.userDataModel.email;
    _phoneNumberController.text = widget.userDataModel.mobile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var space = SizedBox(
      height: 20.0,
    );
    return Scaffold(
      backgroundColor: white_color,
      key: globalKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white_color,
        title: CustomtextFields.textFields(
          text: personalinfo,
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
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      showCupertinoActionSheet(context);
                    },
                    child: Container(
                      height: 190.0,
                      width: 190.0,
                      margin: EdgeInsets.only(top: 25.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: grey_color,
                      ),
                      child: (widget.userDataModel.profilePic != null &&
                          widget.userDataModel.profilePic
                              .isNotEmpty) ||
                          croppedFile != null?Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          croppedFile != null
                              ? ClipOval(
                              child: Image.file(
                                croppedFile,
                                fit: BoxFit.cover,
                              ))
                              : CustomWidgets.getPhotos(
                              productImage:
                              widget.userDataModel.profilePic,
                              height: 190.0,
                              width: 190.0,
                              isShowOverlay: true,
                              boxShape: BoxShape.circle),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                ImageAssests.switchCamera,
                                height: 24.0,
                                width: 24.0,
                              ),
                              CustomtextFields.textFields(
                                  text: changePhoto,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  textColor: white_color)
                            ],
                          )
                        ],
                      ):Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: textColor,
                              ),
                              CustomtextFields.textFields(
                                  text: addProfilePhoto,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  textColor: textColor)
                            ],
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),

                  CustomtextFields.stackTextFromField(errorText:errorPasswordText ,
                    labelText: first_name,
                    hintText: first_name,
                    isErrorShow : isFirstNameErrorShow,
                    focusNode: _firstNameFocusNode,
                    nextFocusNode: _lastNameFocusNode,
                    hintFontSize: 15.0,
                    hintColor: textColorOpacity,
                    readOnly: true,
                    context: context,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textEditingController: _firstNameController,
                    borderColor: isFirstNameErrorShow?redColor:divider_Color,
                    validator: (value) {
                      if (_firstNameController.text.trim().isNotEmpty) {
                        setState(() {
                          isFirstNameErrorShow = false;
                        });
                      }
                    },
                  ),
                  space,
                  CustomtextFields.stackTextFromField(errorText:errorPasswordText ,
                    labelText: last_name,
                    isErrorShow : isLastNameErrorShow,
                    hintText: last_name,
                    focusNode: _lastNameFocusNode,
                    nextFocusNode: _emailFocusNode,
                    hintFontSize: 15.0,
                    hintColor: textColorOpacity,
                    context: context,
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textEditingController: _lastNameController,
                    borderColor: isLastNameErrorShow?redColor:divider_Color,
                    validator: (value) {
                      if (_lastNameController.text.trim().isNotEmpty) {
                        setState(() {
                          isLastNameErrorShow = false;
                        });
                      }
                    },
                  ),

                  space,
                  CustomtextFields.stackTextFromField(errorText:errorPasswordText ,
                    labelText: email,
                    hintText: email,
                    isErrorShow : false,
                    focusNode: _emailFocusNode,
                    nextFocusNode: _phoneNumberFocusNode,
                    hintFontSize: 15.0,
                    hintColor: textColorOpacity,
                    context: context,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    textInputAction: TextInputAction.next,
                    textEditingController: _emailController,
                    borderColor: divider_Color,
                    validator: (value) {

                    },
                  ),
                  space,
                  CustomtextFields.stackTextFromField(errorText:errorPasswordText ,
                    labelText: phone_number,
                    hintText: phone_number,
                    focusNode: _phoneNumberFocusNode,
                    nextFocusNode: null,
                    isErrorShow : false,
                    hintFontSize: 15.0,
                    hintColor: textColorOpacity,
                    context: context,
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textEditingController: _phoneNumberController,
                    borderColor: divider_Color,
                    validator: (value) {

                    },
                  ),
                  space,
                  CustomButtons.loginButton(
                      fontSize: 16.0,
                      textColor: white_color,
                      backgroundColor: buttonColor,
                      radiusSize: 2.0,
                      text: update,
                      function: () {
                        if (isValid()) {
                          callForUpdateProfile();
                        }
                      }
                  ),
                  space
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
          )
        ],
      ),
    );
  }

  bool isValid() {
    if (_firstNameController.text.trim().isEmpty) {
      setState(() {
        isFirstNameErrorShow = true;
      });
      return false;
    } else if (_lastNameController.text.trim().isEmpty) {
      setState(() {
        isLastNameErrorShow = true;
      });
      return false;
    }
    return true;
  }

  void callForUpdateProfile() async {
    if(await CommonMethod.isInternetOn()){
      String image;
      setState(() {
        showLoader = true;
      });
      Map<String, dynamic> param = Map();
      if (croppedFile != null ) {
        Map<String, dynamic> map = Map();
        map["image"] = croppedFile.path;
        Response response = await NetworkCall()
            .callMultipartPostApi(map, ApiConstants.driverUploadImage);
        Map<String, dynamic> data = json.decode(response.body);
        image = data["data"]["image"];
      }
      param["first_name"] = _firstNameController.text.trim();
      param["last_name"] = _lastNameController.text.trim();
      param["profile_image"] = image!=null?image:widget.userDataModel.profilePic;

      Response profileResponse = await NetworkCall()
          .callPostApi(param, ApiConstants.updateProfile);
      Map<String, dynamic> profileData = json.decode(profileResponse.body);
      setState(() {
        showLoader = false;
      });
      globalKey.currentState.showSnackBar(SnackBar(
        content: Text(profileData["message"]),
        duration: Duration(seconds: 1),
      ));
      if (profileData["status"]) {
        SharedPreferences.getInstance().then((sharedPreference) {
          sharedPreference.setString(
              ApiConstants.userData, jsonEncode(profileData["data"]));
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        });
      }
    }else{
      globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
    }

  }

  void showCupertinoActionSheet(context) {
    showCupertinoModalPopup(context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: <Widget>[

              CupertinoActionSheetAction(
                  onPressed: () async{
                    Navigator.pop(context);
                    if (await Permission.camera.status ==
                        PermissionStatus.granted) {
                      selectedProfilePicFromCamera(context);
                    } else {
                      if (await Permission.camera.isUndetermined) {
                        Permission.camera.request().then((value) {
                          print("status $value");
                          if (value.isGranted) {
                            selectedProfilePicFromCamera(context);
                          }
                        });
                      } else {
                        showPermissionDialog(true);

                      }
                    }
                  },
                  child: CustomtextFields.textFields(
                  text: "Camera",
                 fontWeight: FontWeight.w600,
                fontSize: 18.0,
               textColor: buttonColor,
                  )
              ),

              CupertinoActionSheetAction(
                  onPressed: () async{
                    Navigator.of(context).pop();
                    if (await Permission.photos.status ==
                        PermissionStatus.granted) {
                      selectedProfilePicFromGallary(context);
                    } else {
                      if (await Permission.photos.isUndetermined) {
                        Permission.photos.request().then((value) {
                          print("status $value");
                          if (value.isGranted) {
                            selectedProfilePicFromGallary(context);
                          }
                        });
                      } else {
                        showPermissionDialog(false);
                      }
                    }

                  },
                  child:CustomtextFields.textFields(
                    text: "Gallery",
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    textColor: buttonColor,
                  ),
              ),

            ],
            cancelButton: CupertinoActionSheetAction(onPressed: () {
              Navigator.pop(context);
            }, child: CustomtextFields.textFields(
              text: "Cancel",
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              textColor: blackColor,
            ),
            ),
          );
        });
  }

  showPermissionDialog(bool isFromCamera){
    var alertDialog = AlertDialog(
      title: CustomtextFields.textFields(
          text: "PorterChic",
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
          textColor: blackColor
      ),
      content: CustomtextFields.textFields(
          text: "You denied permission for ${isFromCamera?"camera":"gallery"}, please give permission from setting to access it.",
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          maxLines: 4,
          textColor: blackColor
      ),
      actions: <Widget>[
        FlatButton(
          child: CustomtextFields.textFields(
              text: "Okay",
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
              textColor: blackColor
          ),
          onPressed: (){
            openAppSettings();
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: CustomtextFields.textFields(
              text: "Cancel",
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
              textColor: blackColor
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder:(context)=>alertDialog,
        barrierDismissible: false
    );
  }

  Future selectedProfilePicFromGallary(BuildContext context) async{
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50);
    cropImage(file);
  }

  Future selectedProfilePicFromCamera(BuildContext context) async{
    PickedFile file = await ImagePicker().getImage(
        source: ImageSource.camera,imageQuality: 50);
    cropImage(file);
  }

  Future cropImage(PickedFile file) async{
    croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            hideBottomControls: true,
            activeWidgetColor: Colors.grey,
            toolbarTitle: 'Cropper',
            toolbarColor: text_color,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    if(croppedFile!=null){
      setState(() {
      });
      /*await callUploadImage(croppedFile);*/
    }
  }
}
