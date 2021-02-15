import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamp/lamp.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porterchic_driver/app_screen/imagePreviewScreen.dart';
import 'package:porterchic_driver/app_screen/signature_screen.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:url_launcher/url_launcher.dart';

class CameraScreen extends StatefulWidget {

  final String orderId;
  final bool isFromDelivery;
  CameraScreen({this.orderId,this.isFromDelivery});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

    CameraController _cameraController;
    List cameras;
    int selectedCameraIndex;
    String imagePath;
    bool isFlashOn=false;
    int photoId=1;
    String photoIdPath="";
    String photoPackagePath="";
    String photoProductPath="";
    var path;

    @override
  void initState() {

      availableCameras().then((availableCamera){
        cameras = availableCamera;
        if(cameras.length>0){
          setState(() {
            selectedCameraIndex=0;
          });
          initCameraController(cameras[selectedCameraIndex]);
        }
      });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body:   Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 16.0,bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Expanded(
                     child: CustomtextFields.textFields(
                       text: photoId==1?photoIdLabel:photoId==2?photoProductLabel:photoPackageLabel,
                       textColor: white_color,
                       fontSize: 24.0,
                       textAlign: TextAlign.start,
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                   GestureDetector(
                        onTap: ()async{
                          if(await canLaunch(launchWhatsApp(phone: "971555262865"))){
                            await launch(launchWhatsApp(phone: "971555262865"));
                          }else{
                            Fluttertoast.showToast(msg: "Please install WhatsApp");
                          }
                        },
                       child: Image.asset(
                         ImageAssests.supportIcon,
                         height: 24.0,
                         color: white_color,
                         width: 24.0,)
                   )
                 ],
                ),
              ),
              Expanded(
                child: _cameraPreviewWidget()
              ),
              Container(
                margin: EdgeInsets.only(top: 24.0,bottom: 24.0,left: 55.0,right: 55.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap:(){
                          if(isFlashOn){
                          Lamp.turnOff();
                          }else{
                          Lamp.turnOn(intensity: 1.0);
                          }
                          setState(() {
                          isFlashOn = !isFlashOn;
                          });
                       },child: Visibility(
                      visible: false,
                         child: Image.asset(
                            ImageAssests.flash,
                            height: 22.0,
                            width: 25.0,
                          ),
                       )
                    ),
                    GestureDetector(
                      onTap: (){
                        takePhoto(context);
                      },
                        child: Image.asset(
                          ImageAssests.cameraButton,
                          height: 70.0,
                          width: 70.0,
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        if(selectedCameraIndex==0){
                            selectedCameraIndex=1;
                        }else{
                          selectedCameraIndex=0;
                        }
                        initCameraController(cameras[selectedCameraIndex]);
                      },
                        child: Image.asset(ImageAssests.cameraSwitch,height: 22.0,width: 25.0,)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future initCameraController(CameraDescription cameraDescription) async{
      if(_cameraController!=null){
        await _cameraController.dispose();
      }

      _cameraController = CameraController(cameraDescription,ResolutionPreset.medium);

      try{
          await _cameraController.initialize();
      }catch(e){
          print("Exception $e");
      }
      if (mounted) {
        setState(() {});
      }
  }

    Widget _cameraPreviewWidget() {
      if (_cameraController == null || !_cameraController.value.isInitialized) {
        return CustomtextFields.textFields(
          text: "Loading",
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          textColor: white_color,
        );
      }

      return AspectRatio(
        aspectRatio: 16.0/9.0,
        child: CameraPreview(_cameraController),
      );
    }

  void takePhoto(BuildContext context) async{
       path = join((await getTemporaryDirectory()).path,"${DateTime.now()}.png");
      await _cameraController.takePicture(path);
      navigateToPreviewScreen(context,path);

  }

  void navigateToDocuSignScreen(context) {
      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
        return SignatureScreen(orderId: widget.orderId,photoIdPath: photoIdPath,photoProductPath: photoProductPath,photoPackagePath: photoPackagePath,isFromDelivery: widget.isFromDelivery,);
      }
      )).then((value) {
      });
  }

  void navigateToPreviewScreen(BuildContext context, String path) {
      Navigator.push(context, CupertinoPageRoute(
        builder: (context)=>ImagePreviewScreen(isFromNetwork: false,imgUrl: path,)
      )).then((value) => {
        if(value){
          callAddImage(context)
        }
      });
  }

  callAddImage(BuildContext context) {
    if(photoId==1){
      if(widget.isFromDelivery){
        photoIdPath=path;
        navigateToDocuSignScreen(context);
      }else{
        setState(() {
          photoId++;
          photoIdPath=path;
        });
      }
    }else if(photoId==2){
      setState(() {
        photoId++;
        photoProductPath=path;
      });
    }else{
      photoPackagePath=path;
      navigateToDocuSignScreen(context);
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
