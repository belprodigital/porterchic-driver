import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porterchic_driver/app_screen/loginScreen.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:url_launcher/url_launcher.dart';
import 'otpVerificationScreen.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';

class PreviewScreen extends StatefulWidget {
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
         child: Scaffold(
           backgroundColor: white_color,
           body: Container(
             color: white_color,
             width: double.infinity,
             padding: EdgeInsets.only(left: 20.0,right: 20.0),
             child: Column(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.end,
               children: <Widget>[
                 Container(
                   child: Image.asset(ImageAssests.porterChicLogoBlack,height: 200.0,width: 200.0,),
                 ),
                 SizedBox(
                   height: MediaQuery.of(context).size.height/5.0,
                 ),
                 Column(
                   children: [
                     Image.asset(ImageAssests.welcome,width: 200.0,height: 80.0,),
                     SizedBox(
                       height: 20,
                     ),
                    /* CustomtextFields.textFields(
                         fontSize: 16.0,
                         fontFamily: 'JosefinSans',
                         text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum bibendum velit in nunc pulvinar vehicula.",
                         textColor: textColor,
                         maxLines: 3
                     ),
                     SizedBox(
                       height: 50,
                     ),*/
                     CustomButtons.loginButton(
                         fontSize: 16.0,
                         radiusSize:0.0,
                         textColor: white_color,
                         backgroundColor: buttonColor,
                         text:login,
                         function: (){
                           _navigateToSignUpScreen();
                         }
                     ),
                     SizedBox(
                       height: 20,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         CustomtextFields.textFields(
                           fontSize: 15.0,
                           text: wanna_driver,
                           textColor: textColor,
                         ),
                         GestureDetector(
                           onTap: () async{
                             if(await canLaunch(launchWhatsApp(phone: "971555262865"))){
                               await launch(launchWhatsApp(phone: "971555262865"));
                             }else{
                               Fluttertoast.showToast(msg: "Please install WhatsApp application.");
                             }
//                         _navigateToLoginScreen();
                           },
                           child: CustomtextFields.textFields(
                               fontSize: 15.0,
                               text: connectUs,
                               textColor: buttonColor,
                               fontWeight: FontWeight.bold
                           ),
                         ),
                       ],
                     ),
                     SizedBox(
                       height: 30.0,
                     )
                   ],
                 ),
               ],
             ),
           ),
         ),
      ),
    );
  }

  void _navigateToSignUpScreen() {
    Navigator.push(context, CupertinoPageRoute(
      builder: (context)=>LoginScreen()
    ));
  }


  void _navigateToLoginScreen() {
    Navigator.push(context, CupertinoPageRoute(
        builder: (context)=>LoginScreen()
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
