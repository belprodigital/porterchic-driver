import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:porterchic_driver/app_screen/mapScreen.dart';
import 'package:porterchic_driver/app_screen/order_Info_screen.dart';
import 'package:porterchic_driver/model/orderListing.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';


class ItemUpcoming extends StatefulWidget {

  final Active activeOrderList;

  ItemUpcoming({this.activeOrderList});

  @override
  _ItemUpcomingState createState() => _ItemUpcomingState();
}

class _ItemUpcomingState extends State<ItemUpcoming> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => OrderInfoScreen(id:widget.activeOrderList.sId,)));
      },
      child: Container(
        key: Key(widget.activeOrderList.sId+DateTime.now().millisecondsSinceEpoch.toString()),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Card(
            color: white_color,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0)),
            shadowColor: text_color.withOpacity(0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.activeOrderList.productImage,
                          imageBuilder: (context, imageProvider) => (Container(
                            margin: EdgeInsets.only(left:20.0,top:20.0,right:10.0,bottom:10.0),
                            height: 75.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          )),
                          errorWidget: (context, value, obj) => Container(
                              margin: EdgeInsets.only(left:20.0,top:20.0,right:10.0,bottom:10.0),
                              height: 75.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(child: Image.asset(ImageAssests.watch))),
                          placeholder: (context, url) => Container(
                            margin: EdgeInsets.only(left:20.0,top:20.0,right:10.0,bottom:10.0),
                            height: 75.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                              ),
                            ),
                          ),
                        )
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(right:10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top:10.0),
                              alignment: Alignment.centerLeft,
                              child: CustomtextFields.textFields(
                                  text: widget.activeOrderList.productType,
                                  fontSize: 18.0,
                                  textColor: blackColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CustomtextFields.textFields(
                                    text: widget.activeOrderList.pickupDate!=null?getDate(widget.activeOrderList.pickupDate):asSoonAsPossible,
                                    fontSize: 12.0,
                                    fontFamily: 'JosefinSans',
                                    textColor: blackColor,
                                    fontWeight: FontWeight.w600),
                                SizedBox(width: widget.activeOrderList.pickupTime!=null?5.0:0.0,),
                                widget.activeOrderList.pickupTime!=null?CustomtextFields.textFields(
                                    text:widget.activeOrderList.pickupTime,
                                    fontSize: 12.0,
                                    fontFamily: 'JosefinSans',
                                    textColor: blackColor,
                                    fontWeight: FontWeight.w600):Container(),
                                Container(
                                  margin: EdgeInsets.only(left: 3.0, right: 3.0),
                                 child: Image.asset(ImageAssests.rectangleIcon,height:5.0,width:5.0,),
                                ),
                                Expanded(
                                  child: CustomtextFields.textFields(
                                      text:widget.activeOrderList.receiverFirstName+" "+widget.activeOrderList.receiverLastName,
                                      fontSize: 12.0,
                                      fontFamily: 'JosefinSans',
                                      textColor: blackColor,
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top:10.0),
                              child:Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right:10.0),
                                          child:widget.activeOrderList.status>=2 && widget.activeOrderList.isPickupComplted==1?Image.asset(ImageAssests.locationIcon,height: 14.0,width: 11.0,):
                                          Image.asset(widget.activeOrderList.packageSize=="large"? ImageAssests.boxLarge:
                                          widget.activeOrderList.packageSize=="medium"?ImageAssests.boxMedium:ImageAssests.boxSmall,height:20.0,width:20.0,),
                                        ),
                                        Expanded(
                                          child: CustomtextFields.textFields(
                                              text:widget.activeOrderList.distance+" km away" ?? " " +" km away",
                                              fontSize: 12.0,
                                              textAlign: TextAlign.start,
                                              fontFamily: 'JosefinSans',
                                              textColor: textColor,
                                              maxLines: 1,
                                              textOverflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  CustomtextFields.textFields(
                                      text: orderIDLabel+": "+widget.activeOrderList.sId.toString(),
                                    fontSize: 12.0,
                                    fontFamily: 'JosefinSans',
                                    textColor: textColor,
                                    fontWeight: FontWeight.w600),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                 margin: EdgeInsets.only(right:15.0,left:15.0,bottom:15.0,top: 15.0),
                 child:  Row(
                   children: <Widget>[
                     Expanded(
                       child: RaisedButton(
                           elevation: 0.0,
                           onPressed:(){
                             Navigator.push(
                                 context, CupertinoPageRoute(builder: (context) => OrderInfoScreen(id:widget.activeOrderList.sId,)));
                           },
                           padding: EdgeInsets.only(top: 13.0,bottom: 13.0),
                           color: buttonColorOpacity,
                           child: CustomtextFields.textFields(
                             textColor: blackColor,
                             fontFamily: 'JosefinSans',
                             text: orderDetails,
                             fontWeight: FontWeight.w700,
                             fontSize: 16.0,
                           )
                       ),
                     ),
                     SizedBox(
                       width: 17.0,
                     ),
                     Expanded(
                       child: RaisedButton(
                           onPressed:(){
                             callStartPickupApi(
                              widget.activeOrderList.sId,
                              widget.activeOrderList.isPickupComplted
                            );
                             Navigator.push(
                                context, CupertinoPageRoute(
                                builder: (context) => MapScreen(
                                    receiverLatitude: widget.activeOrderList.status>=2 && widget.activeOrderList.isPickupComplted==1?widget.activeOrderList.receiverLatitude:widget.activeOrderList.pickupLatitude,
                                    receiverLongitude: widget.activeOrderList.status>=2 && widget.activeOrderList.isPickupComplted==1?widget.activeOrderList.receiverLongitude:widget.activeOrderList.pickupLongitude,
                                    id: widget.activeOrderList.sId,
                                    isForDeliery: widget.activeOrderList.status>=2 && widget.activeOrderList.isPickupComplted==1?true:false,
                                    isAfterPickUp: false,
                                    mobileNum: widget.activeOrderList.status>=2 && widget.activeOrderList.isPickupComplted==1?widget.activeOrderList.receiverMobile:widget.activeOrderList.pickUpMobile,
                                  )
                                )
                              );
                           },
                           elevation: 0.0,
                           padding: EdgeInsets.only(top: 13.0,bottom: 13.0),
                           color: buttonColor,
                           child: CustomtextFields.textFields(
                             textColor: white_color,
                             fontFamily: 'JosefinSans',

                             text: widget.activeOrderList.status>=2 && widget.activeOrderList.isPickupComplted==1?startDelivery:startPickUp,
                             fontWeight: FontWeight.w700,
                             fontSize: 16.0,
                           )
                       ),
                     ),
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
  String getDate(String pickUpDate) {
    String date = DateFormat("dd MMM yyyy").format(DateTime.parse(pickUpDate));
    String currentDate = CommonMethod.formatDate(DateTime.now().millisecondsSinceEpoch, "dd MMM yyyy");
    if(date==currentDate){
      return "Today";
    }else{
      return date;
    }
  }

  void callStartPickupApi(String sId, int isPickUpCompleted) {
    Map<String,dynamic> param = Map();
    param["order_id"] = sId;
    if(isPickUpCompleted !=1){
      NetworkCall().callPostApi(param, ApiConstants.startPickUp);
    }
  }


}
