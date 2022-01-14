import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppScreen extends StatefulWidget {
  @override
  _WhatsAppScreenState createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white_color,
      body: Container(
        margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only( top: 20.0,bottom: 15.0),
                height:190.0,
                width: 190.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: grey_color,
                ),
                child: Container(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0,bottom: 20.0),
              child: CustomtextFields.textFields(
                  fontSize: 24.0,
                  text: whatsAppService,
                  fontFamily: 'JosefinSans',

                  textColor: blackColor,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  maxLines: 4),
            ),
            /*Container(
              margin: EdgeInsets.only(top: 20.0,bottom: 32.0),
              child: CustomtextFields.textFields(
                  fontSize: 16.0,
                  textOverflow: TextOverflow.ellipsis,
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  textColor: textColor,
                  fontFamily: 'JosefinSans',

                  textAlign: TextAlign.center,
                  maxLines: 4),
            ),*/
            CustomButtons.loginButton(
                fontSize: 16.0,
                textColor: white_color,
                backgroundColor: buttonColor,

                radiusSize: 0.0,

                text: conversationOnWhatsApp,
                function: () async{
                    if(await canLaunch(launchWhatsApp(phone: whatsAppNum))){
                      await launch(launchWhatsApp(phone: whatsAppNum));
                    }else{
                      FlutterToast.showToast(msg: msg_install_whatsapp);
                    }
                }
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
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
