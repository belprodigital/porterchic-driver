import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/order_complete_screen.dart';
import 'package:porterchic_driver/icons/app_bar_icon_icons.dart';
import 'package:porterchic_driver/model/order_details_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';

class SignatureScreen extends StatefulWidget {

  final String orderId;
  final String photoIdPath;
  final String photoPackagePath;
  final String photoProductPath;
  final bool isFromDelivery;
  SignatureScreen({this.orderId,this.photoIdPath,this.photoProductPath,this.photoPackagePath,this.isFromDelivery});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {

  bool showLoader = false;
  GlobalKey<SignatureState> _signKey = GlobalKey();
  ByteData imgeData = ByteData(0);

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
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white_color,
            title: CustomtextFields.textFields(
              text: signatureLabel,
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w600,
              textColor: blackColor,
              fontSize: 25.0,
            ),
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                AppBarIcon.union,
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
                  margin: EdgeInsets.only(
                      left: 20.0, bottom: 20.0, top: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      /*CustomtextFields.textFields(
                        text: introText,
                        fontFamily: 'JosefinSans',

                        maxLines: 4,
                        fontWeight: FontWeight.w400,
                        textColor: textColor,
                        fontSize: 18.0,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),*/
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              color: cardcolor,
                              child: Signature(
                                color: black_color,
                                strokeWidth: 1.5,
                                key: _signKey,
                              ),
                            ),
                            IgnorePointer(
                              ignoring: true,
                              child: Center(
                                child: CustomtextFields.textFields(
                                  text: signHere,
                                  fontSize: 50.0,
                                  textColor: textColor.withOpacity(0.1),
                                  fontFamily: "Mada",
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      CustomButtons.loginButton(
                          backgroundColor: buttonColor,
                          fontFamily: 'JosefinSans',
                          fontSize: 16.0,
                          text: continue_text,
                          textColor: white_color,
                          function: () async {
                            _signKey.currentState.getData().then((value) async {
                              imgeData = await value.toByteData(format: ImageByteFormat.png);
                              setState(() {
                                showLoader=true;
                              });
                              callOrderPickupCompleteApi();
                            });

                         /*   RecipientDefault recip = RecipientDefault(
                              recipientRoleName: 'Visitor',
                              recipientEmail: 'nerapa21@grr.la',
                              recipientName: 'Nehang Patel',
                              inPersonSignerName: 'XYZ',
                              recipientType: RecipientType
                                  .recipientTypeInPersonSigner,
                            );
                            try {
                              myPrintTag("recip", recip.recipientEmail);
                              await DocusignSdk.renderWithTemplateId(
                                  "cb117dc7-ddec-4f8d-a7d9-6d6a202c1c84",
                                  signingMode: DocuSignSigningMode.online,
                                  envelopeDefaults:
                                  EnvelopeDefaults(recipientDefaults: [recip])
                              ).then((value) {
                                print(value);
                              });
                            } catch (e) {

                            }
                            DocusignSdk.syncEnvelopes().then((value) {
                              print('value $value');
                            });*/
                          },
                          radiusSize: 0.0
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
        ),
      ),
    );
  }

  Future callOrderPickupCompleteApi() async {
    Map<String, dynamic> param = Map();
    param["type"] = widget.isFromDelivery ? "2" : "1";
    param["order_id"] = widget.orderId;
    if (widget.isFromDelivery) {
      param["images"] = [
        widget.photoIdPath,

      ];
    } else {
      param["images"] = [
        widget.photoIdPath,
        widget.photoPackagePath,
        widget.photoProductPath,
      ];
    }
    Response response = await NetworkCall().callMultipartPostApi(param, ApiConstants.orderUploadImages);
    Map<String,dynamic> signatureParam = Map();
    signatureParam["type"] = widget.isFromDelivery ? "2" : "1";
    signatureParam["order_id"] = widget.orderId;
    signatureParam["image"] = base64Encode(imgeData.buffer.asUint8List());
    // print(signatureParam["image"]);
    Response signatureResponse = await NetworkCall().callPostApi(signatureParam, ApiConstants.driverUploadSignature);
     Map<String,dynamic> pickUpParam = Map();
    pickUpParam["order_id"]=widget.orderId;
    Response pickUpResponse = await NetworkCall().callPostApi(pickUpParam, widget.isFromDelivery?ApiConstants.deliveryCompleted:ApiConstants.pickUpCompleted);
    setState(() {
      showLoader = false;
    });
    Map<String, dynamic> data = json.decode(response.body);
    OrderDetailsModel orderDetailsModel = OrderDetailsModel.fromJson(data);
    if (orderDetailsModel.status) {
      navigateToOrderCompleteScreen(
          orderDetailsModel.data.order.receiverLatitude,
          orderDetailsModel.data.order.receiverLongitude,
          orderDetailsModel.data.order.receiverMobile
      );
    } else {
      FlutterToast.showToast(msg: data["message"]);
    }
  }

  void navigateToOrderCompleteScreen(String receiverLatitude,
      String receiverLongitude, String receiverMobile) {
    Navigator.push(context, CupertinoPageRoute(
        builder: (context) =>
            OrderCompleteScreen(isFromDelivery: widget.isFromDelivery,
              receiverLatitude: receiverLatitude,
              receiverLongitude: receiverLongitude,
              id: widget.orderId,
              mobileNumber: receiverMobile,)
    ));
  }

}
