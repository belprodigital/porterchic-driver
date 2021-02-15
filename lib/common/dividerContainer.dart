import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';


class DividerContainer{

  static Row divider({
    String text,
    Color textColor,
    double fontSize,
    BuildContext context,
    Color dividerColor,
    /*int maxLines=1,
    String fontFamily = "SFProDisplay",
    FontWeight fontWeight = FontWeight.w400,
    TextAlign textAlign = TextAlign.center,
    TextOverflow textOverflow = TextOverflow.ellipsis*/
  }){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 12.0),
              height: 1,
              color:dividerColor
            ),
          ),
          Center(
            child: CustomtextFields.textFields(
              text: text,
              textColor: textColor,
                fontFamily: 'JosefinSans',
                fontWeight: FontWeight.w400,
               laterSpacing: 2.0,
              fontSize: 14.0
            )
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 12.0),
              height: 1,
              color: dividerColor
            ),
          ),
        ],
      );

  }

}