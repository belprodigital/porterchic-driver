class UserDataModel {
  String userId;
  String accessToken;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String profilePic;
  String address;
  String city;
  String dob;
  String gender;
  String country;
  String emiratesId;
  String emiratesFront;
  String emiratesBack;
  String licenceId;
  String licenceExpiry;
  String passportNumber;
  String passportExpiry;
  String passportImage;
  String rating;

  UserDataModel(
      {this.userId,
        this.accessToken,
        this.firstName,
        this.lastName,
        this.mobile,
        this.email,
        this.profilePic,
        this.address,
        this.city,
        this.dob,
        this.gender,
        this.country,
        this.emiratesId,
        this.emiratesFront,
        this.emiratesBack,
        this.licenceId,
        this.licenceExpiry,
        this.passportNumber,
        this.passportExpiry,
        this.passportImage,
        this.rating});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    accessToken = json['accessToken'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    profilePic = json['profile_pic'];
    address = json['address'];
    city = json['city'];
    dob = json['dob'];
    gender = json['gender'];
    country = json['country'];
    emiratesId = json['emirates_id'];
    emiratesFront = json['emirates_front'];
    emiratesBack = json['emirates_back'];
    licenceId = json['licence_id'];
    licenceExpiry = json['licence_expiry'];
    passportNumber = json['passport_number'];
    passportExpiry = json['passport_expiry'];
    passportImage = json['passport_image'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['accessToken'] = this.accessToken;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['address'] = this.address;
    data['city'] = this.city;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['country'] = this.country;
    data['emirates_id'] = this.emiratesId;
    data['emirates_front'] = this.emiratesFront;
    data['emirates_back'] = this.emiratesBack;
    data['licence_id'] = this.licenceId;
    data['licence_expiry'] = this.licenceExpiry;
    data['passport_number'] = this.passportNumber;
    data['passport_expiry'] = this.passportExpiry;
    data['passport_image'] = this.passportImage;
    data['rating'] = this.rating;
    return data;
  }
}