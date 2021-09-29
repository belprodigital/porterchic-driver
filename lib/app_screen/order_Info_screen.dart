import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:porterchic_driver/app_screen/imagePreviewScreen.dart';
import 'package:porterchic_driver/app_screen/mapScreen.dart';
import 'package:porterchic_driver/common/dividerContainer.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/custom_icons_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/model/orderListing.dart';
import 'package:porterchic_driver/model/order_details_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';

class OrderInfoScreen extends StatefulWidget {
  final String id;

  OrderInfoScreen({this.id});

  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  List<Products> products = List<Products>();
  Order order = Order();
  var showLoader = false;

  @override
  void initState() {
    getOrderdetails();
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
                text: orderDetails,
                fontFamily: 'JosefinSans',
                fontWeight: FontWeight.w600,
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
              actions: [
                Visibility(
                  visible: order.status!=null && order.status==13 ,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: CustomtextFields.textFields(
                          text: canceled,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          textColor: Colors.red
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: getMainWidget()),
      ),
    );
  }

  Widget getPhotosCard({String imagePath}) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: CachedNetworkImage(
          imageUrl: imagePath,
          imageBuilder: (context, imageProvider) => (Container(
            height: 180.0,
            width: 180.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          )),
          errorWidget: (context, value, obj) => 
            Container(
              height: 180.0,
              width: 180.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: text_color, width: 1.0),
                borderRadius: BorderRadius.circular(4.0)
              ),
              child: Center(child: Image.asset(ImageAssests.watch))
            ),
            placeholder: (context, url) => Container(
            height: 180.0,
            width: 180.0,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: text_color, width: 1.0),
                borderRadius: BorderRadius.circular(4.0)),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
              ),
            ),
          ),
        ));
  }

  Widget getMainWidget() {
    if (products.length > 0) {
      return Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom:15.0),
                    child:  Divider(
                      color: divider_Color,
                      thickness: 2.0,
                      height:2.0,
                    )
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[

                          Container(
                            height: 180.0,
                            child: ListView.builder(itemBuilder: (context,index){
                              return  Row(
                                children: <Widget>[
                                  Container(
                                      height: (MediaQuery.of(context).size.width-60)/2,
                                      width:(MediaQuery.of(context).size.width-60)/2,
                                      margin: EdgeInsets.only(right: 5.0,left: 5.0),
                                      child: GestureDetector(
                                          onTap:(){
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) => 
                                                    ImagePreviewScreen(
                                                      imgUrl:products[index].productImage,
                                                      isFromNetwork: true,
                                                    )
                                                )
                                            );
                                          },
                                          child: getPhotosCard(imagePath: products[index].productImage)
                                      )
                                  ),
                                  products[index].packageImage != null ?
                                  Container(
                                      width:(MediaQuery.of(context).size.width-60)/2,
                                      height: (MediaQuery.of(context).size.width-60)/2,
                                      margin: EdgeInsets.only(left: 5.0,right: 5.0),
                                      child: GestureDetector(
                                          onTap:(){
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) => ImagePreviewScreen(
                                                    imgUrl:products[index].packageImage,
                                                    isFromNetwork: true,
                                                  )
                                              )
                                            );
                                           },
                                          child: getPhotosCard(imagePath: products[index].packageImage)
                                      )
                                  ) : Container(),
                                ],
                              );
                            },
                              itemCount: products.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                          Column(
                            children: getPackageInfo(),
                          ),
                          getPickUpInfo(),
                          getDeliveryInfo(),
                          SizedBox(
                            height: order.status<4?65.0:0.0,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: order.status<4,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: CustomButtons.loginButton(
                        fontSize: 16.0,
                        radiusSize:3.0,
                        textColor: white_color,
                        backgroundColor: buttonColor,
                        text: "Start",
                        function: () {
                          startTracking();
                        }),
                  ),
                ),
              ),
            ],
          ));
    } else {
      return Visibility(
        visible: showLoader,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
          ),
        ),
      );
    }
  }

  Widget getTitle({String title}) {
    return Container(
      margin: EdgeInsets.only(top: 24.0),
      child: DividerContainer.divider(
          text: title,
          textColor:textColor,
           fontSize:14.0,
          context: context,
          dividerColor: textColor
      ),
    );
  }

  Widget getDetails(
      {String title,
      String subtitle,
      bool isIcon = false,
      IconData iconData,
      Color color}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomtextFields.textFields(
                  text: title,
                  fontWeight: FontWeight.w400,
                  textColor: textColor,
                  fontFamily: 'JosefinSans',

                  fontSize: 18.0,
                  maxLines: 2,
                  textAlign: TextAlign.start),
            ),
            Expanded(
              child: !isIcon
                  ? CustomtextFields.textFields(
                      text: subtitle,
                      fontWeight: FontWeight.w500,
                  fontFamily: 'JosefinSans',

                  textColor: blackColor,
                      fontSize: 18.0,
                      maxLines: 5,
                      textAlign: TextAlign.end,
                      textOverflow: TextOverflow.ellipsis)
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        iconData,
                        color: color,
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Divider(
          color: divider_Color,
          thickness:1.0,
          height:1.0,
        )
      ],
    );
  }

  List<Widget> getPackageInfo() {
    List<Widget> pickUpInfo = List<Widget>();
    for(int i=0;i<products.length;i++){
      pickUpInfo.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTitle(title: orderInfo.toUpperCase()+" #"+(i+1).toString()),
          getDetails(title: orderIDLabel,subtitle: order.sId),
          getDetails(title: productType,subtitle: products[i].productType),
          getDetails(title: quantityLabel,subtitle: products[i].qty.toString()),
          getDetails(title: descriptionLabel,subtitle: products[i].description),
          // getDetails(title: price,subtitle: products[i].price!=null?products[i].price:""),
          getDetails(title: packageSize,subtitle: products[i].packageSize),
        ],
      ));
    }
    return pickUpInfo;
  }

  Widget getPickUpInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle(title: pickUpInfo.toUpperCase()),
        getDetails(title: first_name,subtitle: order.firstName),
        getDetails(title: last_name,subtitle: order.lastName),
        getDetails(title: phone_number,subtitle: order.mobile),
        getDetails(title: pickUpLocation,subtitle: order.pickupAddress),
        getDetails(title: pickupinstruction,subtitle: order.pickupInstruction?? ""),
        getDetails(title: date,subtitle: order.pickupDate!=null?getDate(order.pickupDate):asSoonAsPossible),
        getDetails(title: time,subtitle: order.pickupTime!=null?order.pickupTime:asSoonAsPossible),
      ],
    );
  }

  Widget getDeliveryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle(title: deliveryInfo),
        getDetails(title: first_name, subtitle:order.receiverFirstName),
        getDetails(title: last_name, subtitle: order.receiverLastName),
        getDetails(title: phone_number, subtitle:order.receiverMobile),
        getDetails(title: email,subtitle: order.receiverEmail),
        getDetails(title: deliveryLocation, subtitle: order.receiverAddress),
        getDetails(
            title: deliveryInstruction,
            subtitle:order.receiverInstruction/*order.receiverInstruction != null
                ? order.receiverInstruction
                : ""*/ ),
        getDetails(
            title: womanDelivery,
            isIcon: true,
            iconData:order.iswomen == 1 ? Icons.done : Icons.clear,
            color: order.iswomen == 1?buttonColor:textColor),
      /*  getDetails(
            title: receiverTrack,
            isIcon: true,
            iconData: order.istrack == 1 ? Icons.done : Icons.clear,
            color: order.iswomen == 1?blackColor:textColor),*/
        getDetails(
            title: giftOption,
            isIcon: true,
            iconData: order.giftOption == 1 ? Icons.done : Icons.clear,
            color: order.giftOption == 1?buttonColor:textColor),
      ],
    );
  }

  Future<void> getOrderdetails() async {
    setState(() {
      showLoader = true;
    });
    Map<String, dynamic> param = Map();
    param["order_id"] = widget.id;
    Response response =
        await NetworkCall().callPostApi(param, ApiConstants.orderDetails);
    Map<String, dynamic> data = json.decode(response.body);
    OrderDetailsModel orderDetailsModel = OrderDetailsModel.fromJson(data);
    if (orderDetailsModel.status) {
      products.addAll(orderDetailsModel.data.products);
      order = orderDetailsModel.data.order;
    } else {}
    setState(() {
      showLoader = false;
    });
  }

  String getDate(String pickUpDate) {
    String date = DateFormat("dd MMM yyyy").format(DateTime.parse(pickUpDate));

    return date;
  }

  void startTracking() {
    callStartPickupApi(order.sId,order.is_pickup_complted);
    Navigator.push(
        context, CupertinoPageRoute(
        builder: (context) => MapScreen(receiverLatitude: order.status>=2 && order.is_pickup_complted==1?order.receiverLatitude:order.pickupLatitude,
          receiverLongitude: order.status>=2 && order.is_pickup_complted==1?order.receiverLongitude:order.pickupLongitude,id: order.sId,isForDeliery: order.status>=2 && order.is_pickup_complted==1?true:false,isAfterPickUp: false,
          mobileNum: order.status>=2 && order.is_pickup_complted==1?order.receiverMobile:order.mobile,)));
  }

  void callStartPickupApi(String sId, int isPickUpCompleted) {
    Map<String,dynamic> param = Map();
    param["order_id"] = sId;
    if(isPickUpCompleted !=1){
      NetworkCall().callPostApi(param, ApiConstants.startPickUp);
    }
  }
}
