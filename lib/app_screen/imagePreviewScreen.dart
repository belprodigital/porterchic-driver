import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';


class ImagePreviewScreen extends StatefulWidget {

  final String imgUrl;
  final bool isFromNetwork;

  ImagePreviewScreen({this.imgUrl,this.isFromNetwork});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor:Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
       leading: IconButton(
         onPressed: () {
           Navigator.pop(context,false);
         },
         icon: Icon(
           BackIcon.union,
           size: 15.0,
           color: white_color,
         ),
       ),
        actions: <Widget>[
          !widget.isFromNetwork?GestureDetector(
            onTap: (){
              Navigator.pop(context,true);
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: 20.0),
                child: CustomtextFields.textFields(
                  text:"Take",
                  textColor: white_color,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ):Container()
        ],
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: widget.isFromNetwork?ImagePreview(widget.imgUrl):Image.file(File(widget.imgUrl),fit: BoxFit.cover,),
      ),
    );
  }

  Widget ImagePreview(String ImageUrl){
    return CachedNetworkImage(
      imageUrl: ImageUrl,
      imageBuilder: (context, imageProvider) => (Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height/2,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      )),
      errorWidget: (context, value, obj) => Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height/2,
          /*decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: text_color, width: 1.0),
              borderRadius: BorderRadius.circular(10.0))*/
          child: Center(child: Image.asset(ImageAssests.watch))),
      placeholder: (context, url) => Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height/2,
            /*decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: text_color, width: 1.0),
            borderRadius: BorderRadius.circular(10.0)),*/
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
          ),
        ),
      ),
    );
  }
}
