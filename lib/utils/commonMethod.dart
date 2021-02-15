
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:porterchic_driver/utils/myprint.dart';

class CommonMethod {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static String formatDate(int timestamp,String formet) {
    var format = new DateFormat(formet);
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }


  static  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;List<LatLng> _convertToLatLng(List points) {
        List<LatLng> result = <LatLng>[];
        for (int i = 0; i < points.length; i++) {
          if (i % 2 != 0) {
            result.add(LatLng(points[i - 1], points[i]));
          }
        }
        return result;
      }
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      }
      while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++)
      lList[i] += lList[i - 2];
    // print(lList.toString());
    return lList;
  }

  static List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  static String getDate(String pickUpDate,String format) {
    String date = DateFormat(format).format(DateTime.parse(pickUpDate));

    return date;
  }

  static Future<bool> isInternetOn()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }else{
      return false;
    }
  }


}