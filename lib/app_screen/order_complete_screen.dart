
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porterchic_driver/app_screen/homeScreen.dart';
import 'package:porterchic_driver/app_screen/mapScreen.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';

class OrderCompleteScreen extends StatefulWidget {

  final bool isFromDelivery;
  final String receiverLatitude;
  final String id;
  final String receiverLongitude;
  final String mobileNumber;
  OrderCompleteScreen({this.isFromDelivery,this.receiverLatitude,this.receiverLongitude,this.id,this.mobileNumber});

  @override
  _OrderCompleteScreenState createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: white_color,
          body: Container(
            margin: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
             children: <Widget>[
               Center(
                 child: Container(
                   margin: EdgeInsets.only(top: 20.0,bottom: 24.0),
                   height: 190.0,
                   width: 190.0,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color: divider_Color.withOpacity(0.2),
                   ),
                   child: Container(),
                 ),
               ),
               CustomtextFields.textFields(
                   fontSize: 28.0,
                   text: widget.isFromDelivery?deliveryCompleted:pickupCompleted,
                   textColor: blackColor,
                   fontWeight: FontWeight.w700,
                   textAlign: TextAlign.center,
                   maxLines: 2
               ),
               SizedBox(
                 height: 24.0,
               ),
               /*CustomtextFields.textFields(
                   fontSize: 16.0,
                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                   textColor: textColor,
                   fontWeight: FontWeight.normal,
                   textAlign: TextAlign.center,
                   maxLines: 4
               ),
               SizedBox(
                 height: 80.0,
               ),*/
               CustomButtons.loginButton(
                   backgroundColor: buttonColor,
                   fontSize: 16.0,
                   text: widget.isFromDelivery?finish:startDelivery,
                   textColor: white_color,
                   function: (){
                      if(widget.isFromDelivery){
                        navigateToHomeScreen();
                      }else{
                        navigateToMapScreen();
                      }
                   },
                   radiusSize: 0.0
               ),
               Visibility(
                 visible: !widget.isFromDelivery,
                 child: Column(
                   children: <Widget>[
                     SizedBox(
                       height: 30.0,
                     ),
                     GestureDetector(
                       onTap: (){
                        navigateToHomeScreen();
                       },
                       child: CustomtextFields.textFields(
                         fontSize: 16.0,
                         text: "Home",
                         textColor: blackColor,
                         fontWeight: FontWeight.w700,
                         textAlign: TextAlign.center,
                       ),
                     ),
                   ],
                 ),
               ),
               SizedBox(
                 height: 30.0,
               ),
             ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
      builder: (context)=>HomeScreen()
    ), (route) => false);
  }

  void navigateToMapScreen() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context)=>MapScreen(receiverLatitude: widget.receiverLatitude,receiverLongitude: widget.receiverLongitude,isForDeliery: true,id: widget.id,isAfterPickUp:true,mobileNum: widget.mobileNumber,)
    )).then((value){
      navigateToHomeScreen();
    });
  }
}
