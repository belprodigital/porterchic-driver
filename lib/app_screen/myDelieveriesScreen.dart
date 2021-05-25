import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:porterchic_driver/app_screen/myratings_screen.dart';
import 'package:porterchic_driver/app_screen/order_Info_screen.dart';
import 'package:porterchic_driver/app_screen/previewsScreen.dart';
import 'package:porterchic_driver/common/dividerContainer.dart';
import 'package:porterchic_driver/icons/driver_icon_icons.dart';
import 'package:porterchic_driver/items/itemPastDeliveries.dart';
import 'package:porterchic_driver/items/itemUpcoming.dart';
import 'package:porterchic_driver/model/orderListing.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';

class MyDelieveriesScreen extends StatefulWidget {
  @override
  _MyDelieveriesScreenState createState() => _MyDelieveriesScreenState();
}

class _MyDelieveriesScreenState extends State<MyDelieveriesScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  ScrollController _scrollController = new ScrollController();
  var firebaseMessaging = FirebaseMessaging();

  bool isListVisible = false;
  var showLoader = false;

  List<Past> pastOrderList=[];
  List<Active> activeOrderList=[];
  List<Active> activeOrders=[];
  List<Active> upComingOrders=[];

  bool isSearchOn = false;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  String currentTimeZone="";

  @override
  void initState() {

//    initFirebaseService();
    getProfile();
    setState(() {
      showLoader=true;
    });
    callOrderListApi(searchText: searchController.text.trim(),);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () {
            return callOrderListApi(searchText: searchController.text.trim(),);
          },
          child: Container(
             padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: orderSummeryBgColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: search,
                              suffixIcon: IconButton(icon: Icon(Icons.close,size: 24.0,color: textColor,),
                                onPressed: () {
                                  setState(() {
                                    isSearchOn=false;
                                    searchController.text="";
                                  });
                                  Future.delayed(Duration(milliseconds: 500),(){
                                    setState(() {
                                      showLoader=true;
                                    });
                                    callOrderListApi(searchText:searchController.text.trim());
                                  });

                                },
                              ),
                              prefixIcon: Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Icon(DriverIcon.search,size: 16.0,color: textColor,)),
                              hintStyle: TextStyle(
                                  color: black_color.withOpacity(0.2),
                                  fontSize: 16.0,
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none
                          ),
                          onChanged: (text){
                            if(text.trim().isEmpty){
                              isSearchOn=false;
                              FocusScope.of(context).requestFocus(FocusNode());
                            }else{
                              isSearchOn=true;
                            }
                            setState(() {
                            });
                            Future.delayed(Duration(milliseconds: 500),(){
                              setState(() {
                                showLoader=true;
                              });
                              callOrderListApi(searchText: text.trim());
                            });
                          },
                          onFieldSubmitted: (value) {
                            searchFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          cursorColor: text_color,
                          focusNode: searchFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: black_color.withOpacity(0.2),
                              fontSize: 16.0,
                              fontFamily: 'JosefinSans',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                showLoader?Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                    ),
                  ),
                ):Expanded(
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          activeOrderList.length>0?Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                visible: activeOrders.length>0,
                                child: SizedBox(
                                  height:20.0,
                                ),
                              ),
                              Visibility(
                                visible: activeOrders.length>0,
                                child: DividerContainer.divider(
                                  text: "ACTIVE",
                                  textColor:textColor,
                                  fontSize:14.0,
                                  context: context,
                                  dividerColor: divider_Color,
                                ),
                              ),

                              Visibility(
                                visible: activeOrders.length>0,
                                child: ListView.builder(
                                  itemCount: activeOrders.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, int index) {
                                    return ItemUpcoming(activeOrderList:activeOrders[index]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: upComingOrders.length>0,
                                child: SizedBox(
                                  height:20.0,
                                ),
                              ),
                              Visibility(
                                visible: upComingOrders.length>0,
                                child: DividerContainer.divider(
                                  text: "UPCOMING",
                                  textColor:textColor,
                                  fontSize:14.0,
                                  context: context,
                                  dividerColor: divider_Color,
                                ),
                              ),
                              Visibility(
                                visible: upComingOrders.length>0,
                                child: ListView.builder(
                                  itemCount: upComingOrders.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, int index) {
                                    return ItemUpcoming(activeOrderList:upComingOrders[index]);
                                  },
                                ),
                              )
                            ],
                          ):isSearchOn?Column(
                            children: <Widget>[
                              SizedBox(
                                height:20.0,
                              ),
                              DividerContainer.divider(
                                text: "UPCOMING",
                                textColor:textColor,
                                fontSize:14.0,
                                context: context,
                                dividerColor: divider_Color,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height/2,
                                child: Center(
                                                  child: CustomtextFields
                                                      .textFields(
                                                          text:
                                                              "No items were found",
                                                          textColor: blackColor,
                                                          fontSize: 16.0,
                                                          fontFamily: "Mada",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              DividerContainer.divider(
                                                text: "UPCOMING",
                                                textColor: textColor,
                                                fontSize: 14.0,
                                                context: context,
                                                dividerColor: divider_Color,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 20.0, bottom: 24.0),
                                                width: 180,
                                                height: 180,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          ImageAssests
                                                              .upcomingImage),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              /*Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.0,bottom: 24.0),
                                  height: 180.0,
                                  width: 180.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: grey_color,
                                  ),
                                  child: Container(),
                                ),
                              ),*/
                                              CustomtextFields.textFields(
                                  fontSize: 28.0,
                                  text: "You are super superhero",
                                  textColor: blackColor,
                                  fontFamily: 'JosefinSans',

                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.center,
                                  maxLines: 2
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              /* CustomtextFields.textFields(
                                        fontSize: 16.0,
                                        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                        textColor: textColor,
                                        fontFamily: 'JosefinSans',

                                        fontWeight: FontWeight.w400,
                                         textAlign: TextAlign.center,
                                        maxLines: 2
                                    ),
                                    SizedBox(
                                      height: 60.0,
                                    ),*/
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top:15.0),
                            child: DividerContainer.divider(
                              text: "PAST DELIVERIES",
                              textColor:divider_text_Color,
                              fontSize:14.0,

                              context: context,
                              dividerColor: divider_Color,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              if(pastOrderList.length>0){
                                setState(() {
                                  isListVisible = !isListVisible;
                                });
                              }else{
                                Fluttertoast.showToast(msg: noPastOrders);
                              }
                            },
                            child:Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.only(top: 25.0),
                                child: Center(child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(

                                      height: 30.0,width: 30.0,
                                      decoration: BoxDecoration(
                                          color: buttonColor,
                                          image: DecorationImage(
                                              scale: 3.0,
                                              image: AssetImage(ImageAssests.refreshIcon)
                                          ),
                                          shape: BoxShape.circle

                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    isListVisible ?
                                    Column(
                                      children: [
                                        CustomtextFields.textFields(
                                            text: "Hide Past" ,
                                            fontFamily: 'JosefinSans',
                                            textColor: textColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700

                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        CustomtextFields.textFields(
                                            text: "Deliveries"
                                            ,fontFamily: 'JosefinSans',
                                            textColor: textColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700

                                        ),
                                      ],
                                    )
                                        :
                                    Column(
                                      children: [
                                        CustomtextFields.textFields(
                                            text: "Show Past" ,
                                            fontFamily: 'JosefinSans',
                                            textColor: textColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700

                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        CustomtextFields.textFields(
                                            text: "Deliveries"
                                            ,fontFamily: 'JosefinSans',
                                            textColor: textColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700

                                        ),
                                      ],
                                    ),
                                  ],
                                )

                                  /*Image.asset(isListVisible?ImageAssests.hidePastDeliveries:ImageAssests.refreshIcon,height:24.0,)*/

                                )
                            ) ,
                          ),
                          Visibility(
                            visible: isListVisible,
                            child: ListView.builder(
                              itemCount: pastOrderList.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, CupertinoPageRoute(
                                          builder: (context)=>OrderInfoScreen(id: pastOrderList[index].sId,)
                                      ));
                                    },
                                    child: ItemPastDeliveries(pastItems: pastOrderList[index],)
                                );
                              },
                            ),
                          )
                        ],
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getInfoCard({String title}) {
    return Container(
      decoration: BoxDecoration(
          color: orderSummeryBgColor, borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
      child: CustomtextFields.textFields(
          text: title,
          fontSize: 12.0,
          textColor: white_color,
          fontWeight: FontWeight.normal),
    );
  }

  void _navigateToOrderInfoScreen(String id) {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => OrderInfoScreen(id: id,)));

  }

  Future callOrderListApi({String searchText}) async{

    if(await CommonMethod.isInternetOn()){
      // myPrintTag("timeZone",DateTime.now().toLocal().timeZoneName);
      currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      Map<String,dynamic> params = Map();
      params["search"]=searchText;
      params["timezone"]= currentTimeZone;
      Response response = await NetworkCall().callPostApi(params, ApiConstants.orderList);

      Map<String,dynamic> data = jsonDecode(response.body);

      OrderListingModel orderListing = OrderListingModel.fromJson(data);
      if(orderListing.status){
        if(pastOrderList.length>0){
          pastOrderList.clear();
        }
        pastOrderList.addAll(orderListing.data.orderList.past);
        if(activeOrderList.length>0){
          activeOrderList.clear();
          activeOrders.clear();
          upComingOrders.clear();
        }
        activeOrderList.addAll(orderListing.data.orderList.active);
        for(int i=0;i<activeOrderList.length;i++){
          if(activeOrderList[i].status>=2 && activeOrderList[i].isPickupComplted==1){
            activeOrders.add(activeOrderList[i]);
          }else{
            upComingOrders.add(activeOrderList[i]);
          }
        }
      }
    }else{
      _globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
    }
    setState(() {
      showLoader=false;
    });
    //Fluttertoast.showToast(msg:data["message"] );

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

  void initFirebaseService() {
    firebaseMessaging.getToken().then((value){
      myPrintTag("token", value);
    });
    if(Platform.isIOS){
      firebaseMessaging.requestNotificationPermissions();
    }
    firebaseMessaging.configure(
      onMessage: (Map<String,dynamic> message) async{
            myPrintTag("new notification", message);
          showNotification(message: message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        redirectToNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onMessage>>> $message");
        redirectToNotification(message);

      },
    );
  }

  void showNotification({@required Map<String,dynamic> message}) {
    showSimpleNotification(
      GestureDetector(
        onTap: (){
          redirectToNotification(message);
        },
        child: Container(
          decoration: BoxDecoration(
              color: white_color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.0),
                bottomRight: Radius.circular(2.0),
              )
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Platform.isIOS?Image.asset(message["type"]=="Order picked up"?ImageAssests.deliverdNoti:
                  message["type"]=="assign_order"?ImageAssests.createOrderNoti:
                  message["type"]=="new_feedback"?ImageAssests.feedBackNoti:ImageAssests.deliverdNoti,height: 17.0,width: 17.0,color: blueColor,):
                  Image.asset(message["data"]["type"]=="Order picked up"?ImageAssests.deliverdNoti:
                  message["type"]=="assign_order"?ImageAssests.createOrderNoti:
                  message["type"]=="new_feedback"?ImageAssests.feedBackNoti:ImageAssests.deliverdNoti,height: 17.0,width: 17.0,color: blueColor,),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: CustomtextFields.textFields(
                      text: Platform.isIOS?message["title"]:message["data"]["title"],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      textColor: blackColor,
                      textOverflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 3.0,left: 32.0),
                child: CustomtextFields.textFields(
                    text: Platform.isIOS?message["message"]:message["data"]["message"],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    textColor: textColor,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    maxLines: 5
                ),
              ),
            ],
          ),
        ),
      ),
      slideDismiss: true,
      background: white_color,

    );
  }

  redirectToNotification(Map<String, dynamic> message){
    if(Platform.isIOS){
      if(message["type"] == "new_feedback"){
        Navigator.push(context, CupertinoPageRoute(
            builder: (context)=>MyRatingsScreen()
        ));

      }else{
        Navigator.push(context, CupertinoPageRoute(
            builder: (context) => OrderInfoScreen(id: message["order_id"],)
        ));
      }

    }else{
      if(message["data"]["type"] == "new_feedback"){
        Navigator.push(context, CupertinoPageRoute(
            builder: (context)=>MyRatingsScreen()
        ));

      }else{
        Navigator.push(context, CupertinoPageRoute(
            builder: (context) => OrderInfoScreen(id: message["data"]["order_id"],)
        ));
      }

    }
  }

  void getProfile() async{
    Map<String,dynamic> param = Map();
    Response response = await NetworkCall().callPostApi(param,ApiConstants.getProfile);
    Map<String,dynamic> data = json.decode(response.body);
    if(data["status"]){
      SharedPreferences.getInstance().then((sharedPref){
        sharedPref.setString(ApiConstants.userData,json.encode(data["data"]));
        sharedPref.setBool(ApiConstants.newOrder,data["data"]["assign_order"]==1?true:false);
        sharedPref.setBool(ApiConstants.orderStatus,data["data"]["order_status"]==1?true:false);
        sharedPref.setBool(ApiConstants.feedBack,data["data"]["new_feedback"]==1?true:false);
        if(data["data"]["status"]==2){
          sharedPref.clear();
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => PreviewScreen()),
              (route) => false);
          Fluttertoast.showToast(
              msg:
                  "Your account is deactivated by admin. Please contact support team");
        }
      });
    }
  }

}
