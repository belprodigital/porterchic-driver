
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiConstatnts.dart';

class NetworkCall{

  Future<Response> callPostApi(Map<String,dynamic> param, String methodName,{String accessToken}) async{

    Map<String,String> header = await getHeaders(methodName,accessToken: accessToken);
    myPrintTag("headers", header);
    myPrintTag("body", param);
    myPrintTag("Api", methodName);
    Response response = await http.post(ApiConstants.base_url+methodName,headers: header,body: jsonEncode(param));
    myPrintTag("Api $methodName response", response.body);
    return response;
  }

  Future<Response> callMultipartPostApi(Map<String,dynamic> param, String methodName) async{
    Map<String,String> header = await getHeaders(methodName);
    var request = http.MultipartRequest("POST",Uri.parse(ApiConstants.base_url+methodName));
    request.headers.addAll(header);
    if(methodName!=ApiConstants.driverUploadImage){
      request.fields["order_id"]=param["order_id"];
      request.fields["type"]=param["type"];
      if(methodName==ApiConstants.driverUploadSignature){
          request.files.add(await http.MultipartFile.fromString("image", param["image"]));
      }else{
        List<String> images = param["images"];
        for(int i=0; i<images.length;i++){
          request.files.add(await http.MultipartFile.fromPath("images", images[i]));
        }
      }
    }else {
      request.files.add(await http.MultipartFile.fromPath(
          "image",
          param["image"],
      )
      );
    }
    myPrintTag("param", request.files);
    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);
    myPrintTag("response", response.body);
    return response;
  }

  Future<Map<String,String>> getHeaders(String methodName,{String accessToken}) async{
    Map<String,String> header = Map();
    header["Content-Type"] = "application/json";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if((methodName == ApiConstants.resendOtp || methodName == ApiConstants.otpVerify || methodName == ApiConstants.resetPassword) && accessToken!=null){
      header["auth"] = accessToken;
    }else if( methodName!=ApiConstants.login){
      if(sharedPreferences.getString(ApiConstants.accessToken)!=null){
        header["auth"] = sharedPreferences.getString(ApiConstants.accessToken);
      }
    }
    return header;
  }

}