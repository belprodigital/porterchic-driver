import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:porterchic_driver/app_screen/otpVerificationScreen.dart';
import 'package:porterchic_driver/app_screen/pickup_qrcode_screen.dart';
import 'package:porterchic_driver/app_screen/scan_qrcode_screen.dart';
import 'package:porterchic_driver/icons/back_icon_icons.dart';
import 'package:porterchic_driver/model/direction_model.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customButtons.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';
//import 'package:workmanager/workmanager.dart';
import 'homeScreen.dart';

/*
const fetchBackground = "fetchBackground";
Position userLocation;

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
         Location().onLocationChanged.listen((latLng) {
           userLocation = Position(latitude: latLng.latitude,longitude: latLng.longitude)
        });
        break;
    }
    return Future.value(true);
  });
}
*/

class MapScreen extends StatefulWidget {
  final String receiverLatitude;
  final String receiverLongitude;
  final String id;
  final bool isForDeliery;
  final bool isAfterPickUp;
  final String mobileNum;
  MapScreen({this.receiverLatitude,this.receiverLongitude,this.id,this.isForDeliery,this.isAfterPickUp,this.mobileNum});

  @override
  MapScreenState createState() => MapScreenState(receiverLatitude: this.receiverLatitude,receiverLongitude: this.receiverLongitude);
}

class MapScreenState extends State<MapScreen> {

  final String receiverLatitude;
  final String receiverLongitude;
  String currentTimeZone="";


  MapScreenState({this.receiverLatitude,this.receiverLongitude});
  Completer<GoogleMapController> _controller = Completer();
  static double zooms=18.4746;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.205081, 55.270666),
    zoom: 18.4746,
  );
  Set<Marker> _markers = {

  } ;
  //37.788129 , -122.406755
  var isBottomSheetOpen=false;
  PersistentBottomSheetController _bottomSheetController;
  static Location location = Location();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  BitmapDescriptor locationIcon;
  BitmapDescriptor pickUpIconIcon;
  Set<Polyline> _polylines = {};
  Polyline polyline;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  var isCurrentLocation=false;
  var isDeliveryStart=false;
  var isDeliveryComplete=false;
  List<Legs> legs = List<Legs>();
  String directionText="";
  String arrivalText="";
  var stepCount=0;
  var locationCount = 0;
  String image =  ImageAssests.turnLeft;
  String grayImage = ImageAssests.turnLeft;
  LocationData locationData;
  Timer timer;
  static var position = Position();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    Wakelock.enable();
    SharedPreferences.getInstance().then((sharedPreferences) {
      this.sharedPreferences = sharedPreferences;
      setState(() {
      });
      getPermission();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: isBottomSheetOpen?blackColorOpacity:white_color,
      child: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () {
            if(widget.isAfterPickUp){
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                  builder: (context)=>HomeScreen()
              ), (route) => false);
              return Future.value(true);
            }else{
              Navigator.pop(context);
              return Future.value(true);
            }
          },
          child: Scaffold(
            key: _globalKey,
            backgroundColor: white_color,
            body: Container(
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    myLocationEnabled: false,
                    myLocationButtonEnabled:false,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onTap: (value){
//                updateLocation(value);
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    polylines: _polylines,
                    markers: _markers,
                    zoomControlsEnabled:true,
                    zoomGesturesEnabled:true,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 54.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          child: Container(
                            padding: EdgeInsets.only(left: 8.0,right: 20.0,top: 16.0,bottom: 16.0),
                            color: isDeliveryComplete?blackColor:white_color,
                            width: double.infinity,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if(widget.isAfterPickUp){
                                      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                                          builder: (context)=>HomeScreen()
                                      ), (route) => false);
                                      return Future.value(true);
                                    }else{
                                      Navigator.pop(context);
                                      return Future.value(true);
                                    }
                                  },
                                  icon: Icon(
                                    BackIcon.union,
                                    size: 14.0,
                                    color: isDeliveryComplete?white_color:blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: CustomtextFields.textFields(
                                      text: arrivalText,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w700,
                                      maxLines: 2,
                                      textColor: isDeliveryComplete?white_color:blackColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            /*GestureDetector(
                              onTap: (){
                                getPermission();
                              },
                              child: Visibility(
                                visible: !isCurrentLocation,
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 15.0,left: 20.0,right: 20.0),
                                    child: Image.asset(ImageAssests.setLocation,height: 52.0,width: 52.0,)),
                              ),
                            ),*/
                            GestureDetector(
                              onTap: ()=>launch("tel://"+widget.mobileNum),
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 15.0,left: 20.0,right: 20.0),
                                  child: Image.asset(ImageAssests.call,height: 52.0,width: 52.0,)),
                            ),
                            Visibility(
                              visible: isDeliveryStart,
                                child: getDirectionCard(white_color,24.0,blackColor,ImageAssests.turnLeft,52.0,directionText,20.0)),
                            /*Visibility(
                              visible: isDeliveryStart  ,
                                child: getDirectionCard(mapCardBgColor,24.0,black_color,ImageAssests.turnRightGrey,16.0,directionText,20.0)),*/
                            Visibility(
                              visible: isDeliveryComplete,
                                child: getPickupCard()
                            ),
                            Visibility(
                              visible: !isDeliveryComplete,
                              child: Container(
                                margin: EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 8.0),
                                child: CustomButtons.loginButton(
                                    backgroundColor: buttonColor,
                                    fontSize: 16.0,
                                    text: widget.isForDeliery?deliverComplete:pickUpComplete,
                                    textColor: white_color,
                                    function: (){
                                        setState(() {
                                          isDeliveryStart=false;
                                          timer.cancel();
                                        });
                                        openBottonSheetDialog();
                                    },
                                    radiusSize: 0.0
                                ),
                              ),
                            )

                           /* Container(
                              margin: EdgeInsets.only(left: 20.0,right: 20.0),
                              decoration: BoxDecoration(
                                  color: white_color
                              ),
                              child: Column(
                                children: <Widget>[
                                  getDirectionCard(white_color,24.0,blackColor,ImageAssests.turnLeft,52.0),
                                  getDirectionCard(mapCardBgColor,16.0,black_color,ImageAssests.turnRightGrey,16.0),
                                ],
                              ),
                            ),*/
//                          getPickupCard(),
                          ],
                        )
                      ],
                    ),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Container(
                      color: isBottomSheetOpen?blackColor.withOpacity(0.4):Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDirectionCard(Color bgColor, double fontSize, Color textColor, String image, double size,String directionText, double margin) {
    return Container(
      margin: EdgeInsets.only(left: margin,right: margin),
      decoration: BoxDecoration(
          color: bgColor
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left :20.0),
            child: Image.asset(bgColor==mapCardBgColor?this.grayImage:this.image,height: size,width: size,),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: CustomtextFields.textFields(
                  text: directionText,
                  textColor: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  textOverflow: TextOverflow.ellipsis
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getPickupCard() {
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getDirectionCard(white_color,24.0,blackColor,ImageAssests.packageBlue,42.0,directionText,00.0),
            Container(
              margin: EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
              child: CustomButtons.loginButton(
                backgroundColor: buttonColor,
                fontSize: 16.0,
                text: widget.isForDeliery?deliver:pickUp,
                textColor: white_color,
                function: (){
                    openBottonSheetDialog();
                },
                radiusSize: 0.0
              ),
            )
          ],
        ),
      ),
    );
  }

  openBottonSheetDialog() {
    setState(() {
      isBottomSheetOpen=true;
    });
    _bottomSheetController = _globalKey.currentState.showBottomSheet((context){
      return Container(
        padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 40.0),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomtextFields.textFields(
              text:reachedYourDestination,
              fontWeight: FontWeight.w600,
              textColor: blackColor,
              fontSize: 24.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            /*CustomtextFields.textFields(
              text:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
              fontWeight: FontWeight.w400,
              textColor: text_color,
              maxLines: 3,
              fontSize: 16.0,
            ),
            SizedBox(
              height: 32.0,
            ),*/
            Container(
                margin: EdgeInsets.only(right: 8.0,left: 8.0,bottom: 8.0),
                child: CustomButtons.loginButton(
                    backgroundColor: buttonColor,
                    fontSize: 16.0,
                    text: yesNotifyClient,
                    textColor: white_color,
                    function: () async {
                      _bottomSheetController.close();
                      if(await CommonMethod.isInternetOn()){
                        navigateToPickupQrScreen();
                      }else{
                        _globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
                      }
                    },
                    radiusSize: 0.0
                ),
            ),
            SizedBox(
              height: 32.0,
            ),
            GestureDetector(
              onTap: (){
                _bottomSheetController.close();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomtextFields.textFields(
                    text:notYet,
                    fontWeight: FontWeight.w700,
                    textColor: textColor,
                    fontSize: 16.0,
                  ),
                  CustomtextFields.textFields(
                    text:" "+continueDriving,
                    fontWeight: FontWeight.w700,
                    textColor: blackColor,
                    fontSize: 16.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      );
    },
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
    ));

    _bottomSheetController.closed.then((value){
      setState(() {
        isBottomSheetOpen=false;
      });
    });
  }

  Future<void> getCurrentLocation() async {
     try {

       locationData = await location.getLocation();
           GoogleMapController controller = await _controller.future;
           if(widget.isForDeliery){
        callStartDeliveryApi(locationData);
           }
           CameraPosition cameraPosition = CameraPosition(target: LatLng(
        locationData.latitude,locationData.longitude,
           ),
            zoom: 16.00,
           );
           controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
           // print("position ${locationData.longitude}, ${locationData.latitude}");
           updateCurrentMarker();
     } on Exception catch (e) {
       myPrintTag("error in location ", e.toString());
     }
  }

  void updateCurrentMarker() {

    setState(() {
      isCurrentLocation=true;
      /*_markers.add(
          Marker(
            markerId: MarkerId("current_marker"),
            position: LatLng(locationData.latitude,locationData.longitude),
            icon:locationIcon,
          ),
      );*/
      _markers.add(
          Marker(
              markerId: MarkerId("destination_marker"),
              position: LatLng(double.parse(receiverLatitude),double.parse(receiverLongitude)),
              icon:pickUpIconIcon,
          )
      );
    });
    setPolyPoints(locationData.latitude,locationData.longitude);
  }

  Future<void> getPermission() async {
    bool isLocationOn = sharedPreferences.getBool(ApiConstants.locationOff);
    if(isLocationOn!=null && isLocationOn){
      if(!await Permission.location.isGranted){
        if(await Permission.location.isUndetermined){
          Permission.location.request().then((value){
            if(value.isGranted){
              allowLocation();
            }
          });
        }else{
          openAppSettings();
        }
      }else{
        allowLocation();
      }
    }else{
      var alertDialog = AlertDialog(
        title: CustomtextFields.textFields(
            text: "PorterChic",
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
            textColor: blackColor
        ),
        content: CustomtextFields.textFields(
            text: "You disable the location access from the app setting, please enable it to allow access location",
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            maxLines: 4,
            textColor: blackColor
        ),
        actions: <Widget>[
          FlatButton(
            child: CustomtextFields.textFields(
                text: "Turn on",
                fontWeight: FontWeight.w500,
                fontSize: 19.0,
                textColor: blackColor
            ),
            onPressed: (){
              sharedPreferences.setBool(ApiConstants.locationOff,true);
              getPermission();
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: CustomtextFields.textFields(
              text: "Cancel",
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
              textColor: blackColor
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      );
      showDialog(context: context,
        builder:(context)=>alertDialog,
        barrierDismissible: false
      );
    }
  }

  Future<void> allowLocation() async {
    if (!await location.serviceEnabled()) {
      location.requestService().then((value) async {
        if (value) {
          sharedPreferences.setBool(ApiConstants.locationOff, true);
          await setLocationIcon();
          await getCurrentLocation();
          // initWorkManager();
          await getLocationUpdate();
        }
      });
    } else {
      sharedPreferences.setBool(ApiConstants.locationOff, true);
      await setLocationIcon();
      await getCurrentLocation();
      // initWorkManager();
      await getLocationUpdate();
    }
  }

  Future setLocationIcon() async{
    locationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)),ImageAssests.direction,);
    pickUpIconIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)),
        widget.isForDeliery?ImageAssests.pickUpMapIcon:ImageAssests.deliveryLocationPin);
  }

  Future setPolyPoints(double latitude, double longitude) async{
    try{
      Response response = await http.post("https://maps.googleapis.com/maps/api/directions/json?origin="+latitude.toString()+","+longitude.toString()+"&destination="+receiverLatitude+","+receiverLongitude+"&mode=driving&key="+googleMapApiKey);

      myPrintTag("response",response.body);
      Map<String,dynamic> data =  jsonDecode(response.body);
      DirectionModel directionModel = DirectionModel.fromJson(data);
      if(directionModel.routes.length>0){

        print("the latitufe is $latitude");
        print("the latitufe is $longitude");
        print("the latitufe is $receiverLatitude");
        print("the latitufe is $receiverLongitude");

        double bearing = await Geolocator().bearingBetween(latitude,longitude,
            directionModel.routes[0].legs[0].steps[0].endLocation.lat,
            directionModel.routes[0].legs[0].steps[0].endLocation.lng);
        print("the bearing value is $bearing");

        setState(() {
          _markers.add(
              Marker(
                markerId: MarkerId("current_marker"),
                position: LatLng(latitude,longitude),
                  icon:locationIcon,
                  rotation:bearing
                 //rotation:latLong.heading
              )
                );
        });
        if(legs!=null){
          legs.clear();
        }
        legs.addAll(directionModel.routes[0].legs);
        if(polylineCoordinates!=null){
          polylineCoordinates.clear();
        }
        polylineCoordinates.addAll(CommonMethod.convertToLatLng(CommonMethod.decodePoly(directionModel.routes[0].overviewPolyline.points)));

        setState(() {

          if(!mounted){
            return;
          }
          polyline = Polyline(
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            geodesic: true,
            points: polylineCoordinates,
          );
          if (_polylines != null) {
            _polylines.clear();
          }
          _polylines.add(polyline);
          isDeliveryStart = true;
          int arrivalSec = legs[0].duration.value;
          double hours = arrivalSec / 3600;
          int hour = hours.round();
          print("the hours is $hour");
          //double minutes = arrivalSec/60;
          double minutes = arrivalSec % 3600 / 60;
          print("the minutes is $minutes");
          int minute = minutes.round();

          String suffixArrivalText = legs[0].distance.value > 1000
              ? legs[0].distance.text
              : legs[0].distance.value.toString() + " m";
          String preffixArrivalText = legs[0].duration.text;
          /*if(hour>0){
            if(hour>1){
              if(minute>0){
                preffixArrivalText = hour.toString()+" hours "+minute.toString()+" minutes";
              }else{
                preffixArrivalText = hour.toString()+" hours";
              }
            }else{
              if(minute>0){
                preffixArrivalText = hour.toString()+" hour "+minute.toString()+" minutes";
              }else{
                preffixArrivalText = hour.toString()+" hour";
              }
            }
          }else{
            preffixArrivalText = minute.toString()+" minutes";
          }*/
          arrivalText = "Arrival in "+preffixArrivalText+" ("+suffixArrivalText+")";
          if(legs[0].steps.length==1){
            if(legs[0].distance.value<10){
              directionText = legs[0].endAddress;
              arrivalText = widget.isForDeliery?arrivedToDeliver:arrivedToPickup;
              image = widget.isForDeliery?ImageAssests.deliveryLocation:ImageAssests.packageBlue;

              setState(() {
                isDeliveryComplete=true;
                isDeliveryStart=false;
                timer.cancel();
              });
            }else{
              image = ImageAssests.straightIcon;
              grayImage = widget.isForDeliery?ImageAssests.location:ImageAssests.packageBlack;
              directionText =  legs[0].steps[0].distance.text+" Ahead";
            }
          }else{
            if(legs[0].steps[1].maneuver=="turn-left" || legs[0].steps[1].maneuver=="keep-left" || legs[0].steps[1].maneuver=="turn-slight-left" || legs[0].steps[1].maneuver=="roundabout-left" ){
              image = ImageAssests.turnRight;
              grayImage = ImageAssests.greyTurnRight;
            }else if(legs[0].steps[1].maneuver=="turn-right" || legs[0].steps[1].maneuver=="keep-right" || legs[0].steps[1].maneuver=="turn-slight-right" || legs[0].steps[1].maneuver=="roundabout-right"){
              image = ImageAssests.turnLeft;
              grayImage = ImageAssests.greyTurnLeft;
            }else if(legs[0].steps[1].maneuver=="uturn-right"){
              image = ImageAssests.uTurn;
              grayImage = ImageAssests.greyUTurnRight;
            }else if(legs[0].steps[1].maneuver=="uturn-left"){
              image = ImageAssests.uTurnLeft;
              grayImage = ImageAssests.greyUTurn;
            }
            directionText = legs[0].steps[1].maneuver+" "+legs[0].steps[0].distance.value.toString() + " m";
          }
        });
      }else{
        setState(() {
          _markers.add(
              Marker(
                  markerId: MarkerId("current_marker"),
                  position: LatLng(latitude,longitude),
                  icon:locationIcon,
                //rotation:latLong.heading
              )
          );
          arrivalText = "No routes found.";
        });
      }
    }catch(e){
      if(!mounted){
        return;
      }
      setState(() {
        _markers.add(
            Marker(
              markerId: MarkerId("current_marker"),
              position: LatLng(latitude,longitude),
              icon:locationIcon,
              //rotation:latLong.heading
            )
        );
        arrivalText = "No routes found.";
      });
    }

  }

  Future getLocationUpdate() async {

      LatLng latLng;
      location.changeSettings(interval: 2000);
      location.onLocationChanged.listen((latLong) async {
        print("the heading value is ${latLong.heading}");
        if(!mounted){
          return;
        }
       /* setState(() {
          _markers.add(
              Marker(
                markerId: MarkerId("current_marker"),
                position: LatLng(latLong.latitude,latLong.longitude),
                  icon:locationIcon,
                 rotation:bearing
                 //rotation:latLong.heading
              )
                );
        });*/
        position = Position(latitude:latLong.latitude,longitude:latLong.longitude);
      });
        timer = Timer.periodic(Duration(
            seconds: 2
        ), (timer) async {
            updateDriverLocation(position.latitude,position.longitude);
            GoogleMapController controller = await _controller.future;
            CameraPosition cameraPosition = CameraPosition(target: LatLng(
              position.latitude,position.longitude,
            ),
              zoom: 16.00,
            );
            //controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setPolyPoints(position.latitude, position.longitude);

        });
    }

@override
  void dispose() {
  Wakelock.disable();
    if(timer!=null){
      timer.cancel();
//      Workmanager.cancelAll();
    }
    super.dispose();
  }

   navigateToPickupQrScreen() async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    Map<String,dynamic> param = Map();
    param["order_id"]=widget.id;
    if(widget.isForDeliery){
      param["type"]="deliver";
    }else{
      param["type"]="pickup";
    }
    NetworkCall().callPostApi(param, ApiConstants.orderNotifyCustomer);
    if(widget.isForDeliery){
      Map<String,dynamic> deliveryParam = Map();
      deliveryParam["order_id"]= widget.id;
      NetworkCall().callPostApi(deliveryParam, ApiConstants.deliveryOtp);
    }
    // Map<String,dynamic> pickUpParam = Map();
    /*pickUpParam["order_id"]=widget.id;
    param["timezone"]= currentTimeZone;
    NetworkCall().callPostApi(pickUpParam, widget.isForDeliery?ApiConstants.deliveryCompleted:ApiConstants.pickUpCompleted);*/
    Navigator.push(context, CupertinoPageRoute(
      builder: (context)=>widget.isForDeliery?OtpVerificationScreen(isFromDelivery: true,orderId: widget.id,):PickUpQrScreen(sId: widget.id,)
    ));
  }

  Future<void> updateDriverLocation(double latitude, double longitude) async{
    Map<String,dynamic> param = Map();
    param["order_id"] = widget.id;
    param["latitude"] = latitude;
    param["longitude"] = longitude;
    param["address"] = "";
    await NetworkCall().callPostApi(param, ApiConstants.updateLocation);
  }

  void initWorkManager() async{
   /*  Workmanager.initialize(
      ,
      isInDebugMode: true,
    );

     Workmanager.registerPeriodicTask(
      "1",
      fetchBackGround,
      frequency: Duration(seconds: 2),
    );*/
  }

  void callStartDeliveryApi(LocationData locationData) {

    try{
      updateDriverLocation(locationData.latitude, locationData.longitude).then((value) async {
        Map<String,dynamic> param = Map();
        param["order_id"] = widget.id;
        await NetworkCall().callPostApi(param, ApiConstants.startDelivery);
      }); 
    }catch(e){
      myPrintTag("crash in api ", e.toString());
    }
  }

}
