import 'dart:core';
import 'dart:developer';

bool isPrint=true;

myPrint(value){
  if(isPrint==true){
    log("$value");
  }
}

myPrintTag(tag,value){
  if(isPrint==true){
    log("$tag $value");
  }
}