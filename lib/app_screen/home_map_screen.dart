import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:porterchic_driver/items/itemUpcoming.dart';
import 'package:porterchic_driver/model/direction_model.dart';
import 'package:porterchic_driver/model/orderListing.dart';
import 'package:porterchic_driver/networkCall/apiConstatnts.dart';
import 'package:porterchic_driver/networkCall/networkCalling.dart';
import 'package:porterchic_driver/styles/colors.dart';
import 'package:porterchic_driver/styles/customTextFields.dart';
import 'package:porterchic_driver/styles/strings.dart';
import 'package:porterchic_driver/utils/commonMethod.dart';
import 'package:http/http.dart' as http;
import 'package:porterchic_driver/utils/imagesAssests.dart';
import 'package:porterchic_driver/utils/myprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMapScreen extends StatefulWidget {
  @override
  _HomeMapScreenState createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.205081, 55.270666),
    zoom: 18.4746,
  );
  Set<Marker> _markers = {

  } ;
  Location location = Location();
  BitmapDescriptor locationIcon;
  BitmapDescriptor activePickUpIconIcon;
  BitmapDescriptor activeDeliveryLocatioIcon;
  BitmapDescriptor pickUpIcon;
  BitmapDescriptor deliveryIcon;
  Set<Polyline> _polyLines = {};
  LocationData locationData;
  Polyline polyline;
  int index;
  bool isInfoVisible = false;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<Active> activeOrderList=List<Active>();
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPreferences){
      this.sharedPreferences=sharedPreferences;
      getPermission();
    });
    setLocationIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              polylines: _polyLines,
              onMapCreated: (controller){
                _controller.complete(controller);
              },
              onTap: (position){

              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              compassEnabled: false,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 20.0,right: 20.0),
              child: index!=null?ItemUpcoming(activeOrderList: activeOrderList[index],):Container()
          ),
        ],
      ),
    );
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
            text: "Porter chic",
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
          getCurrentLocation();
          if(await CommonMethod.isInternetOn()){
            callOrderListApi();
          }else{
            globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
          }
        }
      });
    } else {
      sharedPreferences.setBool(ApiConstants.locationOff, true);
      getCurrentLocation();
      if(await CommonMethod.isInternetOn()){
        callOrderListApi();
      }else{
        globalKey.currentState.showSnackBar(SnackBar(content: Text(noInternet),));
      }
    }
  }

  Future<void> getCurrentLocation() async {
    locationData = await location.getLocation();
    GoogleMapController controller = await _controller.future;
    CameraPosition cameraPosition = CameraPosition(target: LatLng(
      locationData.latitude,locationData.longitude,
    ),
      zoom: 16.00,

    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // print("position ${locationData.longitude}, ${locationData.latitude}");
    updateCurrentMarker();
  }

  void updateCurrentMarker() {
    setState(() {
      _markers.add(
        Marker(
            markerId:MarkerId("current Location"),
            icon: locationIcon,
            position: LatLng(locationData.latitude,locationData.longitude),
        )
      );
    });
  }

  Future setLocationIcon() async{
    locationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)), ImageAssests.direction);
    activePickUpIconIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)), ImageAssests.deliveryLocationPin);
    activeDeliveryLocatioIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)), ImageAssests.pickUpMapIcon);
    pickUpIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)), ImageAssests.disableDeliverLocationPin);
    deliveryIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromHeight(10.0)), ImageAssests.disablePickupIcon);
  }

  Future callOrderListApi() async{
    Map<String,dynamic> params = Map();
    Response response = await NetworkCall().callPostApi(params, ApiConstants.orderList);

    Map<String,dynamic> data = jsonDecode(response.body);

    OrderListingModel orderListing = OrderListingModel.fromJson(data);
    if(orderListing.status){
      if(activeOrderList.length>0){
        activeOrderList.clear();
      }
      activeOrderList.addAll(orderListing.data.orderList.active.where((element) => element.pickupDate==null ||
          element.pickupDate==CommonMethod.formatDate(DateTime.now().millisecondsSinceEpoch, "yyyy-MM-dd") ||
          (element.status<4 && element.pickUpTime.isNotEmpty) ).toList());
    myPrintTag("tag", activeOrderList.length);
      addMarkers();
    }
  }

  void addMarkers({int index}) {
    for(int i=0;i<activeOrderList.length;i++){
      _markers.add(
        Marker(
            markerId: MarkerId("marker #${activeOrderList[i].sId}"),
          position: activeOrderList[i].status>=2 && activeOrderList[i].pickUpTime.isNotEmpty?
          LatLng(double.parse(activeOrderList[i].receiverLatitude),double.parse(activeOrderList[i].receiverLongitude)):
          LatLng(double.parse(activeOrderList[i].pickupLatitude),double.parse(activeOrderList[i].pickupLongitude)),
          icon: getIcon(i,index),
          onTap:(){
              _markers.clear();
              updateCurrentMarker();
              
              addMarkers(index: i);
            setState(() {
              this.index = i ;
              isInfoVisible=true;
            });
              if(activeOrderList[i].status<=2 && activeOrderList[i].pickUpTime.isEmpty){
                _markers.add(
                    Marker(
                        markerId: MarkerId("deliverMarker #${activeOrderList[i].sId}"),
                        position: LatLng(double.parse(activeOrderList[i].receiverLatitude),double.parse(activeOrderList[i].receiverLongitude)),
                        icon: activeDeliveryLocatioIcon
                    )
                );
                setPolyLines(sourceLatitude: activeOrderList[i].pickupLatitude, sourceLongitude: activeOrderList[i].pickupLongitude,
                  destinationLatitude: activeOrderList[i].receiverLatitude,destinationLongitude: activeOrderList[i].receiverLongitude
                );
              }else{
                setPolyLines(sourceLatitude: activeOrderList[i].receiverLatitude, sourceLongitude: activeOrderList[i].receiverLongitude,
                destinationLatitude: locationData.latitude.toString(),destinationLongitude: locationData.longitude.toString());
              }
          }
        ),
      );
      setState(() {

      });
    }
  }

  Future setPolyLines({String sourceLatitude , String sourceLongitude,String destinationLatitude , String destinationLongitude}) async{
    try{
      Response response = await http.post("https://maps.googleapis.com/maps/api/directions/json?origin="+destinationLatitude+","+destinationLongitude+"&destination="+sourceLatitude+","+sourceLongitude+"&mode=driving&key="+googleMapApiKey);
      Map<String,dynamic> data =  jsonDecode(response.body);
      myPrintTag("response", response.body);
      DirectionModel directionModel = DirectionModel.fromJson(data);

      if(polylineCoordinates!=null){
        polylineCoordinates.clear();
      }
      polylineCoordinates.addAll(CommonMethod.convertToLatLng(CommonMethod.decodePoly(directionModel.routes[0].overviewPolyline.points)));

      setState(() {
        polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          width: 5,
          patterns: [
            PatternItem.gap(10.0),
            PatternItem.dash(40.0),
          ],
          points: polylineCoordinates,
        );
        if(_polyLines!=null){
          _polyLines.clear();
        }
        _polyLines.add(polyline);
      });
    }catch(e){
      setState(() {
        if(_polyLines!=null){
          _polyLines.clear();
        }
      });
    }

  }

  BitmapDescriptor getIcon(int i, int index) {
    if(activeOrderList[i].status>=2 && activeOrderList[i].pickUpTime.isNotEmpty){
      if(index==i){
        return activeDeliveryLocatioIcon;
      }else{
        return deliveryIcon;
      }
    }else{
      if(index==i){
        return activePickUpIconIcon;
      }else{
        return pickUpIcon;
      }
    }
  }
}
