
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/otpVerificationScreen.dart';
import 'package:porterchic_driver/app_screen/whatsapp_screen.dart';
import 'package:porterchic_driver/common/dividerContainer.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrCodeScreen extends StatefulWidget {

  final String orderId;
  ScanQrCodeScreen({this.orderId});

  @override
  _ScanQrCodeScreenState createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {

  final GlobalKey qrKey = GlobalKey(debugLabel: "qrCode");
  QRViewController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 16.0,bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: CustomtextFields.textFields(
                              text:scanQrCode,
                              textColor: white_color,
                              fontSize: 24.0,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                              onTap: () async{
                                if(await canLaunch(launchWhatsApp(phone: whatsAppNum))){
                                  await launch(launchWhatsApp(phone: whatsAppNum));
                                }else{
                                  Fluttertoast.showToast(msg: msg_install_whatsapp);
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
                      child: Stack(
                        children: <Widget>[
                          QRView(
                            onQRViewCreated: (controller ) {
                              this.controller=controller;
                              controller.scannedDataStream.listen((event) {
                                if(event==widget.orderId){

                                }
                              });
                          }, key: qrKey,

                          ),
                          /*Container(
                            color: Colors.black.withOpacity(0.1),
                          )*/
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 56.0),
                    child: Image.asset(ImageAssests.subtraction,fit: BoxFit.cover,width: double.infinity,height: double.infinity,)),
                Container(
                  margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 30.0),
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DividerContainer.divider(
                          text: havingProblems.toUpperCase(),
                          context: context,
                          textColor: white_color,
                          dividerColor: white_color
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: CustomButtons.loginButton(
                            backgroundColor: buttonColor,
                            fontSize: 16.0,
                            text: sendCodeBySms,
                            textColor: white_color,
                            function: (){
                            Fluttertoast.showToast(msg: "Otp sent successfully");
                            navigateToOtpScreen();
                            },
                            radiusSize: 0.0
                        ),
                      ),
                      SizedBox(height: 26.0,),
                      GestureDetector(
                        onTap:()async{
                          if(await canLaunch(launchWhatsApp(phone: whatsAppNum))){
                            await launch(launchWhatsApp(phone: whatsAppNum));
                          }else{
                            Fluttertoast.showToast(msg: msg_install_whatsapp);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(ImageAssests.supportIcon,height: 24.0,width: 24.0,color: white_color,),
                            SizedBox(width: 8.0,),
                            CustomtextFields.textFields(
                              fontSize: 17.0,
                              text:contactSupport,
                              fontWeight: FontWeight.w700,
                              textColor: white_color,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  void navigateToOtpScreen() async{
    Map<String,dynamic> param = Map();
    param["order_id"]= widget.orderId;
     NetworkCall().callPostApi(param, ApiConstants.deliveryOtp);
      Navigator.push(context, CupertinoPageRoute(
          builder: (context)=>OtpVerificationScreen(isFromDelivery: true,orderId: widget.orderId,)
      ));
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
