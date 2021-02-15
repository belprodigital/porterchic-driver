
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class CustomtextFields{
  static Text textFields({
    String text,
    Color textColor,
    double fontSize,
    int maxLines=1,
    double laterSpacing =0.0,
    fontFamily: 'JosefinSans',
    FontWeight fontWeight = FontWeight.w400,
    TextAlign textAlign = TextAlign.center,
    TextOverflow textOverflow = TextOverflow.ellipsis
  }){
    return Text(text,
      style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          letterSpacing: laterSpacing
      ),
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
    );
  }

  static TextFormField textFromField({
    TextEditingController textEditingController,
    String hintText,
    Color hintColor,
    double fontSize,
    BuildContext context,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType keyboardType,
  }){
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: hintColor.withOpacity(0.2),
            fontSize: fontSize,
            fontWeight: FontWeight.normal
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: text_color,
              width: 0.3,
            )
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: text_color,
              width: 0.3,
            )
        ),
      ),
      onFieldSubmitted: (value) {
        focusNode.unfocus();
        FocusScope.of(context)
            .requestFocus(nextFocusNode);
      },
      cursorColor: text_color,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
    );
  }

  static TextFormField textFromFields({
    TextEditingController textEditingController,
    String hintText,
    String labelText,
    Color hintColor,
    double fontSize,
    double leftPadding=16.0,
    BuildContext context,
    bool obsecureText,
    Function onEditingComplete,
    Function validator,
    Color borderColor,
    int maxLength=10000,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType keyboardType,
  }){
    return TextFormField(
      onChanged:validator ,
      onEditingComplete: onEditingComplete,
      controller: textEditingController,
      obscureText: obsecureText,
      //validator: validator,
      //autovalidate:true,
      maxLength: maxLength,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:EdgeInsets.only(left:leftPadding) ,
        labelText: labelText,
        counterText: "",
        labelStyle: TextStyle(
            color: textColor,
            fontSize: 16.0,
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            color: hintColor,
            fontFamily: 'JosefinSans',
            fontSize: fontSize,
            fontWeight: FontWeight.w400
        ),
        focusedBorder: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color:borderColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
        /*focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(
              color: text_color,
              width: 0.3,
            )
        ),
        enabledBorder:  UnderlineInputBorder(
            borderSide: BorderSide(
              color: text_color,
              width: 0.3,
            )
        ),*/
      ),
      onFieldSubmitted: (value) {
        focusNode.unfocus();
        FocusScope.of(context)
            .requestFocus(nextFocusNode);
      },
      style: TextStyle(
          color: blackColor,
          fontFamily: 'JosefinSans',
          fontSize: fontSize,
          fontWeight: FontWeight.w400
      ),
      cursorColor: text_color,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
    );
  }


  static Stack stackTextFromField({
    TextEditingController textEditingController,
    String hintText,
    String labelText,
    Color hintColor,
    double hintFontSize,
    double labelFontSize,
    BuildContext context,
    FocusNode focusNode,
    bool obscureText=false,
    Function validator,
    Color borderColor,
    bool readOnly= false,
    String fontFamily = "JosefinSans",
    int maxLines = 1,
    Function onTap,
    FocusNode nextFocusNode,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType keyboardType,
    bool isErrorShow,
    Color labelColor = textColor,
    String errorText
  }){
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            controller: textEditingController,
            onChanged: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: labelText,
              hintText: hintText,
              hintStyle: TextStyle(
                  color: hintColor,
                  fontFamily: fontFamily,
                  fontSize: hintFontSize,
                  fontWeight: FontWeight.w400
              ),
              labelStyle: TextStyle(
                  color: labelColor,
                  fontFamily: fontFamily,
                  fontSize: hintFontSize,
                  fontWeight: FontWeight.w600
              ),
              contentPadding: EdgeInsets.only(top: 12.0,bottom: 12.0,left: 16.0),
              errorBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  )
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  )
              ),
              focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  )
              ),
              enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  )
              ),
            ),
            onFieldSubmitted: (value) {
              focusNode.unfocus();
              FocusScope.of(context)
                  .requestFocus(nextFocusNode);
            },
            readOnly: readOnly,
            style: TextStyle(
              color: blackColor,
              fontFamily: fontFamily,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: text_color,
            focusNode: focusNode,
            obscureText: obscureText,
            onTap: onTap,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
          ),
        ),
        Visibility(
          visible: isErrorShow,
          child: Positioned(
              bottom:0.0,
              right: 0.0,
              child:Container(
                color: Colors.white,
                margin: EdgeInsets.only(right:10.0),
                padding: EdgeInsets.only(left:10.0,right:10.0),
                child: Text(errorText,style:TextStyle(color:redColor,fontSize:12.0),),
              )
          ),
        )
      ],
    );
  }

  static Positioned labelTextWidget({
    @required String labelText
  }){
    return  Positioned(
        top: 0.0,
        left: 8.0,
        child:Container(
          color: Colors.white,
          margin: EdgeInsets.only(right:10.0),
          padding: EdgeInsets.only(left:8.0,right:8.0),
          child: Row(
            children: <Widget>[
              Text(labelText,style: TextStyle(
                  color: textColor,
                  fontFamily: "JosefinSans",
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600
              ),
              ),
              Text(" *",style: TextStyle(
                  color: redColor,
                  fontFamily: "JosefinSans" ,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600
              ),
              ),
            ],
          ),
        )
    );
  }

}


