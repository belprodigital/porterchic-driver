
import 'package:flutter/material.dart';
import 'customTextFields.dart';

class CustomButtons{
  static ButtonTheme loginButton({
    Color backgroundColor,
    Color textColor,
    String text,
    String fontFamily= 'JosefinSans',
    Function function,
    double fontSize,
    double radiusSize,
  }){
    return ButtonTheme(
      minWidth: double.infinity,
      child: RaisedButton(
          onPressed:function,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSize)
          ),
          padding: EdgeInsets.only(top: 13.0,bottom: 13.0),
          color: backgroundColor,
          child: CustomtextFields.textFields(
            textColor: textColor,
            fontFamily: fontFamily,
            text: text,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          )
      ),
    );
  }
}