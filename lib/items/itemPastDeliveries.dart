import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:porterchic_driver/model/orderListing.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';


class ItemPastDeliveries extends StatefulWidget {

  final Past pastItems;
  ItemPastDeliveries({this.pastItems});

  @override
  _ItemPastDeliveriesState createState() => _ItemPastDeliveriesState();
}

class _ItemPastDeliveriesState extends State<ItemPastDeliveries> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Card(
            color: white_color,
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            shadowColor: cardShadowColor,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.pastItems.productImage,
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
                                  text: widget.pastItems.productType,
                                  fontSize: 18.0,
                                  fontFamily: 'JosefinSans',

                                  textColor: black_color,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              RatingBar(
                                  itemSize:16.0 ,
                                  initialRating: widget.pastItems.rating!=null?0:double.parse(widget.pastItems.rating),
                                   minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                   itemCount: 5,
                                    ignoreGestures: true,
                                    unratedColor: divider_Color,
                                    itemPadding: EdgeInsets.symmetric(horizontal:0.0),
                                   itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                     color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // print(rating);
                              },
                            ),
                                SizedBox(width: 5.0,),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Image.asset(ImageAssests.rectangleIcon,height:5.0,width:5.0,),
                                ),
                                CustomtextFields.textFields(
                                    text:widget.pastItems.receiverFirstName + " " +widget.pastItems.receiverLastName,
                                    fontSize: 13.0,
                                    fontFamily: 'JosefinSans',

                                    textColor: blackColor,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top:10.0,left:5.0),
                              alignment: Alignment.centerLeft,
                              child: CustomtextFields.textFields(
                                      text:delivered+" "+CommonMethod.getDate(widget.pastItems.receiverTime, "dd.MM.yyyy"),
                                      fontSize: 13.0,
                                  fontFamily: 'JosefinSans',

                                  textColor: textColor,
                                      fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
