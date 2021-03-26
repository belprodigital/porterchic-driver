class OrderDetailsModel {
  bool status;
  String message;
  Data data;

  OrderDetailsModel({this.status, this.message, this.data});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
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
  Order order;
  List<Products> products;

  Data({this.order, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  String sId;
  String storeId;
  String userId;
  String pickupAddress;
  String pickupInstruction;
  String pickupLatitude;
  String pickupLongitude;
  String pickupDate;
  String pickupTime;
  String receiverFirstName;
  String receiverLastName;
  String receiverMobile;
  String receiverEmail;
  String receiverAddress;
  String receiverInstruction;
  String receiverLatitude;
  String receiverLongitude;
  int iswomen;
  int giftOption;
  int insurance;
  int istrack;
  int status;
  int paymentStatus;
  Null paymentDetails;
  String driverId;
  String totalAmount;
  String createdAt;
  String updatedAt;
  int isurgent;
  String giftFrom;
  String giftTo;
  String giftMobileNumber;
  String deliveredTime;
  String giftMessages;
  int otp;
  String distance;
  String pickUpTime;
  int is_pickup_complted;
  String receiverTime;
  String driveToReceiver;
  int otpVerify;
  String firstName;
  String lastName;
  String mobile;

  Order(
      {this.sId,
        this.storeId,
        this.userId,
        this.pickupAddress,
        this.pickupInstruction,
        this.pickupLatitude,
        this.pickupLongitude,
        this.pickupDate,
        this.is_pickup_complted,
        this.pickupTime,
        this.receiverFirstName,
        this.receiverLastName,
        this.receiverMobile,
        this.receiverEmail,
        this.receiverAddress,
        this.receiverInstruction,
        this.receiverLatitude,
        this.receiverLongitude,
        this.iswomen,
        this.giftOption,
        this.insurance,
        this.istrack,
        this.status,
        this.paymentStatus,
        this.paymentDetails,
        this.driverId,
        this.totalAmount,
        this.createdAt,
        this.updatedAt,
        this.isurgent,
        this.giftFrom,
        this.giftTo,
        this.giftMobileNumber,
        this.deliveredTime,
        this.giftMessages,
        this.otp,
        this.distance,
        this.pickUpTime,
        this.receiverTime,
        this.driveToReceiver,
        this.otpVerify,
        this.firstName,
        this.lastName,
        this.mobile,
      });

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeId = json['store_id'];
    userId = json['user_id'];
    pickupAddress = json['pickup_address'];
    pickupInstruction = json['pickup_instruction'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    is_pickup_complted = json['is_pickup_complted'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
    receiverFirstName = json['receiver_first_name'];
    receiverLastName = json['receiver_last_name'];
    mobile = json['mobile'];
    receiverMobile = json['receiver_mobile'];
    receiverAddress = json['receiver_address'];
    receiverEmail = json['receiver_email'];
    receiverInstruction = json['receiver_instruction'];
    receiverLatitude = json['receiver_latitude'];
    receiverLongitude = json['receiver_longitude'];
    iswomen = json['iswomen'];
    giftOption = json['gift_option'];
    insurance = json['insurance'];
    istrack = json['istrack'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentDetails = json['payment_details'];
    driverId = json['driver_id'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isurgent = json['isurgent'];
    giftFrom = json['gift_from'];
    giftTo = json['gift_to'];
    giftMobileNumber = json['gift_mobile_number'];
    deliveredTime = json['delivered_time'];
    giftMessages = json['gift_messages'];
    otp = json['otp'];
    distance = json['distance'];
    pickUpTime = json['pick_up_time'];
    receiverTime = json['receiver_time'];
    driveToReceiver = json['drive_to_receiver'];
    otpVerify = json['otp_verify'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['store_id'] = this.storeId;
    data['user_id'] = this.userId;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_instruction'] = this.pickupInstruction;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['pickup_date'] = this.pickupDate;
    data['pickup_time'] = this.pickupTime;
    data['mobile'] = this.mobile;
    data['receiver_first_name'] = this.receiverFirstName;
    data['receiver_last_name'] = this.receiverLastName;
    data['receiver_mobile'] = this.receiverMobile;
    data['receiver_address'] = this.receiverAddress;
    data['receiver_email'] = this.receiverEmail;
    data['receiver_instruction'] = this.receiverInstruction;
    data['receiver_latitude'] = this.receiverLatitude;
    data['receiver_longitude'] = this.receiverLongitude;
    data['iswomen'] = this.iswomen;
    data['gift_option'] = this.giftOption;
    data['insurance'] = this.insurance;
    data['istrack'] = this.istrack;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['payment_details'] = this.paymentDetails;
    data['driver_id'] = this.driverId;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['isurgent'] = this.isurgent;
    data['gift_from'] = this.giftFrom;
    data['gift_to'] = this.giftTo;
    data['gift_mobile_number'] = this.giftMobileNumber;
    data['delivered_time'] = this.deliveredTime;
    data['gift_messages'] = this.giftMessages;
    data['otp'] = this.otp;
    data['distance'] = this.distance;
    data['pick_up_time'] = this.pickUpTime;
    data['receiver_time'] = this.receiverTime;
    data['drive_to_receiver'] = this.driveToReceiver;
    data['otp_verify'] = this.otpVerify;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_pickup_complted'] = this.is_pickup_complted;
    return data;
  }
}

class Products {
  String sId;
  String orderId;
  String productType;
  String packageSize;
  String productImage;
  String packageImage;
  int isSealed;
  String createdAt;
  String updatedAt;
  String price;

  Products(
      {this.sId,
        this.orderId,
        this.productType,
        this.packageSize,
        this.productImage,
        this.packageImage,
        this.isSealed,
        this.createdAt,
        this.updatedAt,
        this.price});

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderId = json['order_id'];
    productType = json['product_type'];
    packageSize = json['package_size'];
    productImage = json['product_image'];
    packageImage = json['package_image'];
    isSealed = json['is_sealed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['order_id'] = this.orderId;
    data['product_type'] = this.productType;
    data['package_size'] = this.packageSize;
    data['product_image'] = this.productImage;
    data['package_image'] = this.packageImage;
    data['is_sealed'] = this.isSealed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['price'] = this.price;
    return data;
  }
}
