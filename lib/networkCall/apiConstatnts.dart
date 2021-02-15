
class ApiConstants {

  //Api
  static String base_url="https://admin.porterchic.com:8443/driver/";   //live url
  // static String base_url="http://4085ea3ca379.ngrok.io/driver/"; //base url

  static String otpVerify="otp-verify";
  static String resendOtp="resend-otp";
  static String login="Login";
  static String logout="log-out";
  static String forgotPassword="forgot-password";
  static String orderList = "order/order-list";
  static String deliveryOtp = "order/delivery-otp";
  static String orderDetails = "order/order-details";
  static String orderNotifyCustomer = "order/notify-customer";
  static String orderUploadImages= "order/upload-images";
  static String resetPassword= "reset-password";
  static String startPickUp= "order/action/pickup";
  static String updateLocation= "order/update-order-address";
  static String startDelivery= "order/action/delivery";
  static String pickUpCompleted= "order/action/pickup_completed";
  static String deliveryCompleted= "order/action/completed";
  static String oredrVerifyOtp= "order/verify-otp";
  static String driverResendOtp= "driver/resend-otp";
  static String driverPickupOtp= "order/pickup-otp";
  static String driverNotificationList = "notification-list";
  static String checkPassword = "check-password";
  static String getProfile = "get-profile";
  static String updateProfile = "update-profile";
  static String driverUploadImage = "driver/upload-image";
  static String driverUploadSignature = "order/upload-signature";
  static String feedbackList = "feedback-list";
  static String drivesData = "drives-data";
  static String updateSetting= "update-setting";

  //sharedPrefrence
  static String secureById = "secure";
  static String userData = "UserData";
  static String isLogin = "isLogin";
  static String accessToken = "aceessToken";
  static String isShowpreview = "isShowPreview";
  static String locationOff = "LocationOff";
  static String newOrder = "newOrder";
  static String orderStatus = "orderStatus";
  static String feedBack = "feedBack";
}