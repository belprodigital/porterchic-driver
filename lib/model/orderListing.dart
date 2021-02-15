class OrderListingModel {
  bool status;
  String message;
  Data data;

  OrderListingModel({this.status, this.message, this.data});

  OrderListingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  OrderList orderList;

  Data({this.orderList});

  Data.fromJson(Map<String, dynamic> json) {
    orderList = json['order_list'] != null
        ? new OrderList.fromJson(json['order_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['order_list'] = this.orderList.toJson();
    }
    return data;
  }
}

class OrderList {
  List<Past> past;
  List<Active> active;

  OrderList({this.past, this.active});

  OrderList.fromJson(Map<String, dynamic> json) {
    if (json['past'] != null) {
      past = new List<Past>();
      json['past'].forEach((v) {
        past.add(new Past.fromJson(v));
      });
    }
    if (json['active'] != null) {
      active = new List<Active>();
      json['active'].forEach((v) {
        active.add(new Active.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.past != null) {
      data['past'] = this.past.map((v) => v.toJson()).toList();
    }
    if (this.active != null) {
      data['active'] = this.active.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Active {
  String sId;
  String pickupAddress;
  String pickupLatitude;
  String pickupLongitude;
  String pickupDate;
  String pickupTime;
  String receiverFirstName;
  String receiverLastName;
  String receiverMobile;
  String pickUpMobile;
  String receiverAddress;
  String receiverInstruction;
  String receiverLatitude;
  String receiverLongitude;
  int iswomen;
  int giftOption;
  int insurance;
  int istrack;
  int status;
  String productImage;
  String productType;
  String packageSize;
  String rating;
  String feedback;
  String distance;
  String receiverTime;
  String pickUpTime;

  Active(
      {this.sId,
        this.pickupAddress,
        this.pickupLatitude,
        this.pickupLongitude,
        this.pickupDate,
        this.pickupTime,
        this.receiverFirstName,
        this.receiverLastName,
        this.receiverMobile,
        this.pickUpMobile,
        this.receiverAddress,
        this.receiverInstruction,
        this.receiverLatitude,
        this.receiverLongitude,
        this.iswomen,
        this.giftOption,
        this.insurance,
        this.istrack,
        this.status,
        this.productImage,
        this.productType,
        this.packageSize,
        this.rating,
        this.feedback,
        this.distance,
        this.receiverTime,
        this.pickUpTime});

  Active.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pickupAddress = json['pickup_address'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
    pickUpMobile = json['pickup_mobile'];
    receiverFirstName = json['receiver_first_name'];
    receiverLastName = json['receiver_last_name'];
    receiverMobile = json['receiver_mobile'];
    receiverAddress = json['receiver_address'];
    receiverInstruction = json['receiver_instruction'];
    receiverLatitude = json['receiver_latitude'];
    receiverLongitude = json['receiver_longitude'];
    iswomen = json['iswomen'];
    giftOption = json['gift_option'];
    insurance = json['insurance'];
    istrack = json['istrack'];
    status = json['status'];
    productImage = json['product_image'];
    productType = json['product_type'];
    packageSize = json['package_size'];
    rating = json['rating'];
    feedback = json['feedback'];
    distance = json['distance'];
    receiverTime = json['receiver_time'];
    pickUpTime = json['pick_up_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['pickup_date'] = this.pickupDate;
    data['pickup_time'] = this.pickupTime;
    data['pickup_mobile'] = this.pickUpMobile;
    data['receiver_first_name'] = this.receiverFirstName;
    data['receiver_last_name'] = this.receiverLastName;
    data['receiver_mobile'] = this.receiverMobile;
    data['receiver_address'] = this.receiverAddress;
    data['receiver_instruction'] = this.receiverInstruction;
    data['receiver_latitude'] = this.receiverLatitude;
    data['receiver_longitude'] = this.receiverLongitude;
    data['iswomen'] = this.iswomen;
    data['gift_option'] = this.giftOption;
    data['insurance'] = this.insurance;
    data['istrack'] = this.istrack;
    data['status'] = this.status;
    data['product_image'] = this.productImage;
    data['product_type'] = this.productType;
    data['package_size'] = this.packageSize;
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    data['distance'] = this.distance;
    data['receiver_time'] = this.receiverTime;
    data['pick_up_time'] = this.pickUpTime;
    return data;
  }
}

class Past {
  String sId;
  String pickupAddress;
  String pickupLatitude;
  String pickupLongitude;
  String pickupDate;
  String pickupTime;
  String receiverFirstName;
  String receiverLastName;
  String receiverMobile;
  String pickUpMobile;
  String receiverAddress;
  String receiverInstruction;
  String receiverLatitude;
  String receiverLongitude;
  int iswomen;
  int giftOption;
  int insurance;
  int istrack;
  int status;
  String productImage;
  String productType;
  String packageSize;
  String rating;
  String feedback;
  String distance;
  String receiverTime;
  String pickUpTime;

  Past(
      {this.sId,
        this.pickupAddress,
        this.pickupLatitude,
        this.pickupLongitude,
        this.pickupDate,
        this.pickupTime,
        this.receiverFirstName,
        this.receiverLastName,
        this.receiverMobile,
        this.pickUpMobile,
        this.receiverAddress,
        this.receiverInstruction,
        this.receiverLatitude,
        this.receiverLongitude,
        this.iswomen,
        this.giftOption,
        this.insurance,
        this.istrack,
        this.status,
        this.productImage,
        this.productType,
        this.packageSize,
        this.rating,
        this.feedback,
        this.distance,
        this.receiverTime,
        this.pickUpTime});

  Past.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pickupAddress = json['pickup_address'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
    pickUpMobile = json['pickup_mobile'];
    receiverFirstName = json['receiver_first_name'];
    receiverLastName = json['receiver_last_name'];
    receiverMobile = json['receiver_mobile'];
    receiverAddress = json['receiver_address'];
    receiverInstruction = json['receiver_instruction'];
    receiverLatitude = json['receiver_latitude'];
    receiverLongitude = json['receiver_longitude'];
    iswomen = json['iswomen'];
    giftOption = json['gift_option'];
    insurance = json['insurance'];
    istrack = json['istrack'];
    status = json['status'];
    productImage = json['product_image'];
    productType = json['product_type'];
    packageSize = json['package_size'];
    rating = json['rating'];
    feedback = json['feedback'];
    distance = json['distance'];
    receiverTime = json['receiver_time'];
    pickUpTime = json['pick_up_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['pickup_date'] = this.pickupDate;
    data['pickup_time'] = this.pickupTime;
    data['pickup_mobile'] = this.pickUpMobile;
    data['receiver_first_name'] = this.receiverFirstName;
    data['receiver_last_name'] = this.receiverLastName;
    data['receiver_mobile'] = this.receiverMobile;
    data['receiver_address'] = this.receiverAddress;
    data['receiver_instruction'] = this.receiverInstruction;
    data['receiver_latitude'] = this.receiverLatitude;
    data['receiver_longitude'] = this.receiverLongitude;
    data['iswomen'] = this.iswomen;
    data['gift_option'] = this.giftOption;
    data['insurance'] = this.insurance;
    data['istrack'] = this.istrack;
    data['status'] = this.status;
    data['product_image'] = this.productImage;
    data['product_type'] = this.productType;
    data['package_size'] = this.packageSize;
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    data['distance'] = this.distance;
    data['receiver_time'] = this.receiverTime;
    data['pick_up_time'] = this.pickUpTime;
    return data;
  }
}