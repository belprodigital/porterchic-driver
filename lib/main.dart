  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:porterchic_driver/app_screen/previewsScreen.dart';
import 'package:porterchic_driver/app_screen/signature_screen.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_screen/homeScreen.dart';
import 'networkCall/apiConstatnts.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_){
    runApp(PorterChicDriver());
  });
}


class PorterChicDriver extends StatefulWidget {
  // This widget is the root of your application.



  @override
  _PorterChicDriverState createState() => _PorterChicDriverState();
}

class _PorterChicDriverState extends State<PorterChicDriver> {
  SharedPreferences sharedPreferences;
  var isShowintro;
  bool isLogin;
  Widget splashWidget;

  @override
  void initState() {
    splashWidget = splashScreenWidget();
    Future.delayed(Duration(seconds: 5),(){
      setState(() {
        splashWidget = getLoginredirection(isShowintro,isLogin);
      });
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.sharedPreferences=value;
        isShowintro=value.getBool(ApiConstants.isShowpreview);
        isLogin = value.getBool(ApiConstants.isLogin);
      });
    });
    // print("-->$isLogin");
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Porter Chic Driver',
        theme: ThemeData(
          primarySwatch: white,
          textSelectionColor: Colors.blueAccent,
        ),
        home: Scaffold(body: splashWidget,backgroundColor: white_color,),
      ),
    );
  }

  Widget getLoginredirection(isShowintro,bool isLogin) {
    myPrintTag("isLogin", isLogin);

    if(sharedPreferences==null){
      return Container();
    }else{
    if(isLogin != null && isLogin){
      return HomeScreen();
    }else{
        return PreviewScreen();
    }
    }
  }

  static const MaterialColor white = const MaterialColor(
    0XFF080E5B,
    const <int, Color>{
      50:  const Color(0XFF080E5B),
      100: const Color(0XFF080E5B),
      200: const Color(0XFF080E5B),
      300: const Color(0XFF080E5B),
      400: const Color(0XFF080E5B),
      500: const Color(0XFF080E5B),
      600: const Color(0XFF080E5B),
      700: const Color(0XFF080E5B),
      800: const Color(0XFF080E5B),
      900: const Color(0XFF080E5B),
    },
  );

  Widget splashScreenWidget() {
    return Center(
      child: Container(
        child: Lottie.asset(ImageAssests.splashLogoBlue,repeat: false,onLoaded: (composition){

        },
        ),
      ),
    );
  }
}

