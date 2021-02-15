import 'package:flutter/material.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:shared_preferences/shared_preferences.dart';



class NotificationScreen extends StatefulWidget {

  final String texts;

  // receive data from the FirstScreen as a parameter
  NotificationScreen({ this.product, @required this.texts}) ;
  final List<Product> product;
  @override
  NotificationScreenState createState() {
    return new NotificationScreenState(texts);
  }
}
class NotificationScreenState extends State<NotificationScreen> {

  final String texts;
  NotificationScreenState(this.texts);
  SharedPreferences sharedPreferences;
  bool isNewOrder=false;
  bool isOrderStatus=false;
  bool feedBack=false ;
  
  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPreferences){
      this.sharedPreferences = sharedPreferences;
      isNewOrder=sharedPreferences.getBool(ApiConstants.newOrder);
      isNewOrder = isNewOrder!=null?isNewOrder:true;
      isOrderStatus=sharedPreferences.getBool(ApiConstants.orderStatus);
      isOrderStatus = isOrderStatus!=null?isOrderStatus:true;
      feedBack=sharedPreferences.getBool(ApiConstants.feedBack);
      feedBack = feedBack!=null?feedBack:true;
      setState(() {

      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: white_color,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white_color,
          title: CustomtextFields.textFields(
            text: texts ,
            textColor: blackColor,
            fontWeight: FontWeight.w500,
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
        ),
        body: new Container(
          padding: new EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              notification(title: newOrders,isSelected: isNewOrder,currentIndex: 0),
              notification(title: ordersStatus,isSelected: isOrderStatus,currentIndex: 1),
              notification(title: feedback,isSelected: feedBack,currentIndex: 2),
            ],
          )
        ));
  }

  Widget notification({String title,bool isSelected,int currentIndex}){

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            children: <Widget>[
              CustomtextFields.textFields(text: title,
                  fontSize: 16.0),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if(currentIndex==0){
                       isNewOrder = !isNewOrder;
                       sharedPreferences.setBool(ApiConstants.newOrder, isNewOrder);
                      }else if(currentIndex==1){
                       isOrderStatus = !isOrderStatus;
                       sharedPreferences.setBool(ApiConstants.orderStatus,isOrderStatus);
                      }else{
                        feedBack = !feedBack;
                        sharedPreferences.setBool(ApiConstants.feedBack, feedBack);
                      }
                    });
                    callUpdateSettingApi(currentIndex: currentIndex);
                  },
                  child: Image.asset(
                    isSelected?ImageAssests.switchOn : ImageAssests.switchOff,
                    width: 32.0,
                    height: 30.0,
                  )),

            ],
          ),
        ),
        Divider(
        )
      ],
    );

  }

  void callUpdateSettingApi({int currentIndex}) async{
    Map<String,dynamic> param = Map();
    if(currentIndex==0){
      param["assign_order"]=isNewOrder?1:0;
    }else if(currentIndex==1){
      param["order_status"]=isOrderStatus?1:0;
    }else{
      param["new_feedback"]=feedBack?1:0;
    }
    NetworkCall().callPostApi(param,ApiConstants.updateSetting,);
  }

}



/*
void main() {
  runApp(new MaterialApp(
    title: 'ListView CheckBox',
    home: NotificationScreen(product: [
      new Product('New orders', true),
      new Product('Deadlines', true),
      new Product('Orders status', false),
      new Product('Feedback', true)
    ]),
  ));
}
*/


final List<Product> notificationItems = [
  Product('New orders', true),
  new Product('Deadlines', true),
  new Product('Orders status', false),
  new Product('Feedback', true)
];


class Product {




  String name;
  bool isCheck;
  Product(this.name, this.isCheck);
}