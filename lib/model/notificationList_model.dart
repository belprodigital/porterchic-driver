class NotificationModel {
  bool status;
  String message;
  Data data;

  NotificationModel({this.status, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
  List<Unread> unread;
  List<Unread> today;
  List<Unread> later;
  int totalPage;

  Data({this.unread, this.today, this.later, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['unread'] != null) {
      unread = new List<Unread>();
      json['unread'].forEach((v) {
        unread.add(new Unread.fromJson(v));
      });
    }
    if (json['today'] != null) {
      today = new List<Unread>();
      json['today'].forEach((v) {
        today.add(new Unread.fromJson(v));
      });
    }
    if (json['later'] != null) {
      later = new List<Unread>();
      json['later'].forEach((v) {
        later.add(new Unread.fromJson(v));
      });
    }
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unread != null) {
      data['unread'] = this.unread.map((v) => v.toJson()).toList();
    }
    if (this.today != null) {
      data['today'] = this.today.map((v) => v.toJson()).toList();
    }
    if (this.later != null) {
      data['later'] = this.later.map((v) => v.toJson()).toList();
    }
    data['total_page'] = this.totalPage;
    return data;
  }
}

class Unread {
  String totalLength;
  String heading;
  String type;
  String message;
  String date;
  String orderId;
  int read;

  Unread(
      {this.totalLength,
        this.heading,
        this.type,
        this.message,
        this.date,
        this.orderId,
        this.read});

  Unread.fromJson(Map<String, dynamic> json) {
    totalLength = json['total_length'];
    heading = json['heading'];
    type = json['type'];
    message = json['message'];
    date = json['date'];
    orderId = json['order_id'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_length'] = this.totalLength;
    data['heading'] = this.heading;
    data['type'] = this.type;
    data['message'] = this.message;
    data['date'] = this.date;
    data['order_id'] = this.orderId;
    data['read'] = this.read;
    return data;
  }
}
/*class Today {
  String totalLength;
  String heading;
  String type;
  String message;
  String date;
  int read;

  Today(
      {this.totalLength,
        this.heading,
        this.type,
        this.message,
        this.date,
        this.read});

  Today.fromJson(Map<String, dynamic> json) {
    totalLength = json['total_length'];
    heading = json['heading'];
    type = json['type'];
    message = json['message'];
    date = json['date'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_length'] = this.totalLength;
    data['heading'] = this.heading;
    data['type'] = this.type;
    data['message'] = this.message;
    data['date'] = this.date;
    data['read'] = this.read;
    return data;
  }
}
class Later {
  String totalLength;
  String heading;
  String type;
  String message;
  String date;
  int read;

  Later(
      {this.totalLength,
        this.heading,
        this.type,
        this.message,
        this.date,
        this.read});

  Later.fromJson(Map<String, dynamic> json) {
    totalLength = json['total_length'];
    heading = json['heading'];
    type = json['type'];
    message = json['message'];
    date = json['date'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_length'] = this.totalLength;
    data['heading'] = this.heading;
    data['type'] = this.type;
    data['message'] = this.message;
    data['date'] = this.date;
    data['read'] = this.read;
    return data;
  }
}*/
