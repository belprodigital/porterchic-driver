import 'package:flutter/material.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/icons/permission_switch_icons.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';


class TermsAndConditionsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white_color,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white_color,
          title: CustomtextFields.textFields(
            text: TermsCondition ,
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
              size: 18.0,
              color: blackColor,
            ),
          ),
        ),
        body: WebView(
          initialUrl: "http://3.101.43.64:3000/pages/term-condition",
          onWebViewCreated: (value){
            value.loadUrl("http://3.101.43.64:3000/pages/term-condition");
          },
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}
