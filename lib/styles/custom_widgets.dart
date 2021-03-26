

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';

import 'colors.dart';

class CustomWidgets{

  static Widget getPhotos({
    @required String productImage,
    double height=100.0,
    double width=100.0,
    bool isShowOverlay=false,
    BoxShape boxShape = BoxShape.rectangle
  }) {
    return  CachedNetworkImage(
      imageUrl: productImage!=null?productImage:"",
      imageBuilder: (context, imageProvider) => Stack(
        children: <Widget>[
          Container(
            height: height,
            width: width,
            decoration: boxShape==BoxShape.rectangle?BoxDecoration(
              shape: boxShape,
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ):BoxDecoration(
              shape: boxShape,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          Visibility(
            visible: isShowOverlay,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                shape: boxShape,
                color: blackColor.withOpacity(0.2)
              ),
            ),
          ),
        ],
      ),
      errorWidget: (context, value, obj) => Container(
          margin: EdgeInsets.only(left:5.0),
          height: height,
          width: width,
          decoration: boxShape==BoxShape.rectangle?BoxDecoration(
            shape: boxShape,
            borderRadius: BorderRadius.circular(8.0)
          ):BoxDecoration(
        shape: boxShape,
      ),
          child: Center(child: Image.asset(ImageAssests.watch))),
      placeholder: (context, url) => Container(
        margin: EdgeInsets.only(left:5.0),
        height: height,
        width: width,
        decoration: boxShape==BoxShape.rectangle?BoxDecoration(
          shape: boxShape,
          borderRadius: BorderRadius.circular(8.0)
        ):BoxDecoration(
          shape: boxShape,
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
          ),
        ),
      ),
    );
  }

}