import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:porterchic_driver/common/dividerContainer.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/model/my_rating_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/custom_widgets.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';

class   MyRatingsScreen extends StatefulWidget {
  @override
  _MyRatingsScreenState createState() => _MyRatingsScreenState();
}

class _MyRatingsScreenState extends State<MyRatingsScreen> {
  List<RatingData> ratingData = List<RatingData>();
  RatingCount ratingCount = RatingCount();
  bool showLoader = false,isApiCall=false;
  int page=0;
  int totalPage=0;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    CommonMethod.isInternetOn().then((isInternetOn){
      if(isInternetOn){
        setState(() {
          showLoader = true;
        });
        getMyRating();
      }else{
        _globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
      }
    });
    _scrollController =  ScrollController()..addListener(_scrollListner);
    super.initState();
  }

  void _scrollListner() {
    if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
      print(isApiCall);
      print(page);
      print(totalPage);
      if(!isApiCall){
        if(page!=totalPage-1){
          CommonMethod.isInternetOn().then((isInternetOn){
            if(isInternetOn){
              page++;
              ratingData.add(RatingData(orderId: "-11"));
              setState(() {

              });
              getMyRating();
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
    return Scaffold(
        backgroundColor: white_color,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white_color,
          title: CustomtextFields.textFields(
            text: myRatings,
            fontWeight: FontWeight.w500,
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
        ),
        body: getMainWidget());
  }

  Widget textfiels(String text) {
    return CustomtextFields.textFields(
        text: text,
        textColor: blackColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500);
  }

  Widget ratingCard(context, RatingData ratingData) {
    return Card(
      key: Key(ratingData.orderId+DateTime.now().millisecondsSinceEpoch.toString()),
      color: white_color,
      elevation: 4.0,
      shadowColor: cardShadowColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                CustomWidgets.getPhotos(productImage: ratingData.productImage,boxShape: BoxShape.rectangle,height: 70.0,width: 70.0),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomtextFields.textFields(
                              text: ratingData.productType ?? "",
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              RatingBar(
                                ignoreGestures: true,
                                glow: false,
                                initialRating: double.parse(ratingData.rating),
                                itemCount: 5,
                                allowHalfRating: true,
                                itemSize: 14.0,
                                itemPadding: EdgeInsets.only(right: 5.0),
                                ratingWidget: RatingWidget(
                                    half: Image.asset(
                                      ImageAssests.halfRating,
                                    ),
                                    full: Image.asset(
                                      ImageAssests.fullRating,
                                    ),
                                    empty: Image.asset(
                                      ImageAssests.emptyRating,
                                    )),
                                onRatingUpdate: (double value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 4.0),
                                child: Image.asset(
                                  ImageAssests.rectangleIcon,
                                  height: 5.0,
                                  width: 5.0,
                                ),
                              ),
                              Expanded(
                                child: CustomtextFields.textFields(
                                    text: ratingData.receiverFirstName!=null?ratingData.receiverFirstName +" "+ratingData.receiverLastName:"",
                                    fontSize: 12.0,
                                    textColor: blackColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomtextFields.textFields(
                              text: "Delivered "+CommonMethod.getDate(ratingData.driveToReceiver!=null?ratingData.driveToReceiver:"2020-09-05T10:39:52.549Z", "dd.MM.yyyy"),
                              fontSize: 12.0,
                              textColor: textColor,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textfiels('Customer Rated'),
                  RatingBar(
                    ignoreGestures: true,
                    glow: false,
                    initialRating: double.parse(ratingData.rating),
                    itemCount: 5,
                    allowHalfRating: true,
                    itemSize: 14.0,
                    itemPadding: EdgeInsets.only(right: 5.0),
                    ratingWidget: RatingWidget(
                        half: Image.asset(
                          ImageAssests.halfRating,
                        ),
                        full: Image.asset(
                          ImageAssests.fullRating,
                        ),
                        empty: Image.asset(
                          ImageAssests.emptyRating,
                        )),
                    onRatingUpdate: (double value) {},
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textfiels('Receiver Rated'),
                  CustomtextFields.textFields(
                      text: noFeedBack,
                      textColor: textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMyRating() async {

    Map<String, dynamic> param = Map();
    param["page"] = page;
    Response response =
        await NetworkCall().callPostApi(param, ApiConstants.feedbackList);
    Map<String, dynamic> data = json.decode(response.body);
    MyRatingModel myRatingModel = MyRatingModel.fromJson(data);
    if (myRatingModel.status) {
      totalPage=myRatingModel.rating.totalPage;
      if (myRatingModel.rating.ratingData.length > 0) {
        if (page == 0) {
          ratingData.clear();
        }else{
          ratingData.removeWhere((element) => element.orderId=="-11");
        }
        ratingData.addAll(myRatingModel.rating.ratingData);
      }
      ratingCount = myRatingModel.rating.ratingCount;
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    setState(() {
      showLoader = false;
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
      if(ratingData.length>0){
        return SingleChildScrollView(
           controller: _scrollController,
          child: Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                ratingDetails(rating: 5,totalRating: ratingCount.fiveStar),
                Divider(),
                ratingDetails(rating: 4,totalRating: ratingCount.fourStar),
                Divider(),
                ratingDetails(rating: 3,totalRating: ratingCount.threeStar),
                Divider(),
                ratingDetails(rating: 2,totalRating: ratingCount.twoStar),
                Divider(),
                ratingDetails(rating: 1,totalRating: ratingCount.oneStar),
                SizedBox(
                  height: 20.0,
                ),
                DividerContainer.divider(
                  fontSize: 14.0,
                  textColor: textColor,
                  text: ratingHistory,
                  context: context,
                  dividerColor: textColor
                ),
                SizedBox(
                  height: 15.0,
                ),
                ListView.builder(
                    itemCount: ratingData.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 8.0),
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, int index) {
                      if(ratingData[index].orderId=="-11"){
                        return Center(
                          child: CircularProgressIndicator(
                            key: Key(ratingData[index].orderId+DateTime.now().millisecondsSinceEpoch.toString()),
                            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                          ),
                        );
                      }else{
                        return ratingCard(context,ratingData[index]);
                      }
                    })
              ],
            ),
          ),
        );
      }else{
        return Center(
          child: textfiels("No rating available"),
        );
      }
    }
    
  }

  Widget ratingDetails({double rating,String totalRating}){
    return SizedBox(
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RatingBar(
            ignoreGestures: true,
            glow: false,
            initialRating: rating,
            itemCount: 5,
            allowHalfRating: true,
            itemSize: 14.0,
            itemPadding: EdgeInsets.only(right: 5.0),
            ratingWidget: RatingWidget(
                half: Image.asset(
                  ImageAssests.halfRating,
                ),
                full: Image.asset(
                  ImageAssests.fullRating,
                ),
                empty: Image.asset(
                  ImageAssests.emptyRating,
                )),
            onRatingUpdate: (double value) {},
          ),
          textfiels(totalRating)
        ],
      ),
    );
  }
}
