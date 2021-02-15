class MyRatingModel {
  bool status;
  String message;
  Rating rating;

  MyRatingModel({this.status, this.message, this.rating});

  MyRatingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    rating = json['data'] != null ? new Rating.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.rating != null) {
      data['data'] = this.rating.toJson();
    }
    return data;
  }
}

class Rating {
  int totalPage;
  RatingCount ratingCount;
  List<RatingData> ratingData;

  Rating({this.totalPage, this.ratingCount, this.ratingData});

  Rating.fromJson(Map<String, dynamic> json) {
    totalPage = json['total_page'];
    ratingCount = json['rating_data'] != null
        ? new RatingCount.fromJson(json['rating_data'])
        : null;
    if (json['data'] != null) {
      ratingData = new List<RatingData>();
      json['data'].forEach((v) {
        ratingData.add(new RatingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_page'] = this.totalPage;
    if (this.ratingCount != null) {
      data['rating_data'] = this.ratingCount.toJson();
    }
    if (this.ratingData != null) {
      data['data'] = this.ratingData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingCount {
  String fiveStar;
  String fourStar;
  String threeStar;
  String twoStar;
  String oneStar;

  RatingCount(
      {this.fiveStar,
        this.fourStar,
        this.threeStar,
        this.twoStar,
        this.oneStar});

  RatingCount.fromJson(Map<String, dynamic> json) {
    fiveStar = json['five_star'];
    fourStar = json['four_star'];
    threeStar = json['three_star'];
    twoStar = json['two_star'];
    oneStar = json['one_star'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['five_star'] = this.fiveStar;
    data['four_star'] = this.fourStar;
    data['three_star'] = this.threeStar;
    data['two_star'] = this.twoStar;
    data['one_star'] = this.oneStar;
    return data;
  }
}

class RatingData {
  String totalLength;
  String rating;
  String productType;
  String driveToReceiver;
  String receiverFirstName;
  String receiverLastName;
  String productImage;
  String packageSize;
  String orderId;

  RatingData(
      {this.totalLength,
        this.rating,
        this.productType,
        this.driveToReceiver,
        this.receiverFirstName,
        this.receiverLastName,
        this.productImage,
        this.packageSize,
        this.orderId
      });

  RatingData.fromJson(Map<String, dynamic> json) {
    totalLength = json['total_length'];
    rating = json['rating'];
    productType = json['product_type'];
    driveToReceiver = json['drive_to_receiver'];
    receiverFirstName = json['receiver_first_name'];
    receiverLastName = json['receiver_last_name'];
    productImage = json['product_image'];
    packageSize = json['package_size'];
    orderId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_length'] = this.totalLength;
    data['rating'] = this.rating;
    data['product_type'] = this.productType;
    data['drive_to_receiver'] = this.driveToReceiver;
    data['receiver_first_name'] = this.receiverFirstName;
    data['receiver_last_name'] = this.receiverLastName;
    data['product_image'] = this.productImage;
    data['package_size'] = this.packageSize;
    data['_id'] = this.orderId;
    return data;
  }
}
