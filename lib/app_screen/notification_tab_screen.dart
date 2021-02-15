import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/app_screen/order_Info_screen.dart';
import 'package:porterchic_driver/common/dividerContainer.dart';
import 'package:porterchic_driver/model/notificationList_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';

import 'myratings_screen.dart';


class NotificationTabScreen extends StatefulWidget {

  NotificationTabScreen({GlobalKey<NotificationTabScreenState> notificationScreenState}):super(key:notificationScreenState);
  @override
  NotificationTabScreenState createState() => NotificationTabScreenState();
}

class NotificationTabScreenState extends State<NotificationTabScreen> {

  List<Unread> newNotificationList = List<Unread>();
  List<Unread> todayNotificationList = List<Unread>();
  List<Unread> laterNotificationList = List<Unread>();
  bool showLoader = false;
  ScrollController _scrollController;
  NotificationModel  notificationListModel;
  int totalPage = 0;
  bool isUnreadEmpty=true,isLaterEmpty=true,isLaterTodayEmpty=true,isApiCall = false;
  int page = 0;
  String currentTimeZone="";
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    CommonMethod.isInternetOn().then((isInternetOn){
      if(isInternetOn){
        setState(() {
          showLoader=true;
        });
        getNotificationList();
      }else{
        _globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
      }
    });
    _scrollController =  ScrollController()..addListener(_scrollListner);
    super.initState();
  }

  void _scrollListner() {
    if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
      if(notificationListModel!=null && !isApiCall){
        if(page!=totalPage){
          CommonMethod.isInternetOn().then((isInternetOn){
            if(isInternetOn){
              page++;
              if(isLaterEmpty){
                if(isLaterTodayEmpty){
                  if(!isUnreadEmpty){
                    newNotificationList.add(Unread(orderId: "-11"));
                  }
                }else{
                  todayNotificationList.add(Unread(orderId: "-11"));
                }
              }else {
                laterNotificationList.add(Unread(orderId: "-11"));
              }
              setState(() {

              });
              getNotificationList();
            }else{
              _globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
            }
          });
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: white_color,
          body: getMainWidget(),
        ),
      ),
    );
  }

  Widget getListView({List<Unread> list,bool isNewNoti,bool isLaterToday}) {
    return ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context,index){
          if(list[index].orderId=="-11"){
            return Center(
              child: CircularProgressIndicator(
                key: Key(list[index].orderId+DateTime.now().millisecondsSinceEpoch.toString()),
                valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
              ),
            );
          }else{
            return GestureDetector(
              key: Key(list[index].orderId+DateTime.now().millisecondsSinceEpoch.toString()),
              onTap:(){
                if(list[index].type=="new_feedback"){
                  Navigator.push(context, CupertinoPageRoute(
                      builder: (context)=>MyRatingsScreen()
                  ));
                }else{
                  Navigator.push(context, CupertinoPageRoute(
                      builder: (context) => OrderInfoScreen(id:list[index].orderId,)
                  ));
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 14.0,bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(list[index].type=="Order picked up"?ImageAssests.deliverdNoti:
                              list[index].type=="assign_order"?ImageAssests.createOrderNoti:
                              list[index].type=="new_feedback"?ImageAssests.feedBackNoti:ImageAssests.deliverdNoti,height: 17.0,width: 17.0,color: list[index].type=="new_feedback"?starColor:isNewNoti?blueColor:textColor,),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: CustomtextFields.textFields(
                                  text: list[index].heading,
                                  fontSize: 16.0,
                                  fontFamily: 'JosefinSans',

                                  fontWeight: FontWeight.w600,
                                  textColor: blackColor,
                                  textOverflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                ),
                              ),
                              CustomtextFields.textFields(
                                text: !isNewNoti && !isLaterToday?CommonMethod.getDate(list[index].date, "dd.MM.yyyy"):getTime(list[index].date),
                                fontSize: 12.0,
                                fontFamily: 'JosefinSans',

                                fontWeight: FontWeight.w600,
                                textColor: !isNewNoti?blackColor:blueColor,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3.0,left: 32.0),
                            child: CustomtextFields.textFields(
                                text: list[index].message,
                                fontSize: 16.0,
                                fontFamily: 'JosefinSans',

                                fontWeight: FontWeight.w400,
                                textColor: textColor,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 5
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }

        }, separatorBuilder: (BuildContext context, int index) {
          return Divider();
    },
    );
  }

  Future<void> getNotificationList() async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    isApiCall=true;
    Map<String,dynamic> param = Map();
    param["page"]= page;
    param["timezone"]= currentTimeZone;
    Response response = await NetworkCall().callPostApi(param, ApiConstants.driverNotificationList);
    Map<String,dynamic> data = json.decode(response.body);
    notificationListModel = NotificationModel.fromJson(data);
    if(notificationListModel.status){
      totalPage = notificationListModel.data.totalPage;
      if(page!=0){
        if(isLaterEmpty){
          if(isLaterTodayEmpty){
            if(!isUnreadEmpty){

              newNotificationList.removeWhere((element) => element.orderId=="-11");
            }
          }else{
            todayNotificationList.removeWhere((element) => element.orderId=="-11");
          }
        }else {
          laterNotificationList.removeWhere((element) => element.orderId=="-11");
        }
      }
          if(notificationListModel.data.unread.length>0){
            if(page==0){
              newNotificationList.clear();
            }
            isUnreadEmpty=false;
            newNotificationList.addAll(notificationListModel.data.unread);
          }
           if(notificationListModel.data.today.length>0){
            if(page==0){
              todayNotificationList.clear();
            }
            isLaterTodayEmpty=false;
            todayNotificationList.addAll(notificationListModel.data.today);
          }
           if(notificationListModel.data.later.length>0){
            if(page==0){
              laterNotificationList.clear();
            }
            isLaterEmpty=false;
            laterNotificationList.addAll(notificationListModel.data.later);
          }

    }
    isApiCall=false;
    setState(() {
      showLoader =false;
    });
  }

  Widget getMainWidget() {
    if(showLoader){
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
        ),
      );
    }else{
      if(newNotificationList.length>0 || todayNotificationList.length>0 || laterNotificationList.length>0){
        return SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            margin: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 23.0,
                ),
                Visibility(
                  visible: newNotificationList.length>0,
                  child: DividerContainer.divider(
                      text:newNotification.toUpperCase(),
                      fontSize: 14.0,
                      textColor: blueColor,
                      context: context,
                      dividerColor: blueColor
                  ),
                ),
                Visibility(
                    visible: newNotificationList.length>0,
                    child: getListView(list: newNotificationList,isNewNoti: true,isLaterToday: false)
                ),
                Visibility(
                  visible: newNotificationList.length>0,
                  child: SizedBox(
                    height: 32.0,
                  ),
                ),
                Visibility(
                  visible: todayNotificationList.length>0,
                  child: DividerContainer.divider(
                      text:laterToday.toUpperCase(),
                      fontSize: 14.0,
                      textColor: textColor,
                      context: context,
                      dividerColor: textColor
                  ),
                ),

                Visibility(
                    visible: todayNotificationList.length>0,
                    child: getListView(list: todayNotificationList,isNewNoti: false,isLaterToday: true)
                ),
                Visibility(
                  visible: todayNotificationList.length>0,
                  child: SizedBox(
                    height: 32.0,
                  ),
                ),
                Visibility(
                  visible: laterNotificationList.length>0,
                  child: DividerContainer.divider(
                      text:later.toUpperCase(),
                      fontSize: 14.0,
                      textColor: textColor,
                      context: context,
                      dividerColor: textColor
                  ),
                ),
                Visibility(
                    visible: laterNotificationList.length>0,
                    child: getListView(list: laterNotificationList,isNewNoti: false,isLaterToday: false)
                ),
              ],
            ),
          ),
        );
      }else{
        return Center(
          child: CustomtextFields.textFields(
            text: "No notification available",
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            textColor: blackColor,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
        );
      }
    }
   
  }

  String getTime(String date) {
    int currentHour = int.parse(CommonMethod.formatDate(DateTime.now().millisecondsSinceEpoch, "HH"));
    int notificationHour = int.parse(CommonMethod.getDate(date, "HH"));
    myPrintTag("currentHour", currentHour);
    myPrintTag("notificationHour", notificationHour);
    if(currentHour>notificationHour){
      myPrintTag("time", (currentHour-notificationHour));
      return (currentHour-notificationHour).toString()+" hour ago";
    }else{
      int currentMin = int.parse(CommonMethod.formatDate(DateTime.now().millisecondsSinceEpoch, "mm"));
      int notificationMin = int.parse(CommonMethod.getDate(date, "mm"));
      myPrintTag("time", currentMin);
      myPrintTag("time", notificationMin);
      if(notificationMin<currentMin){
        return (currentMin-notificationMin).toString()+" min ago";
      }else{
        return "now";
      }

    }
  }

  newReceivedNotification(){
    page=0;
    getNotificationList();
  }
}
