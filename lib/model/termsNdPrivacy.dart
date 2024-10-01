class termNdPrivacy {
  String? message;
  RecordList? recordList;
  int? status;

  termNdPrivacy({this.message, this.recordList, this.status});

  termNdPrivacy.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    recordList = json['recordList'] != null
        ? new RecordList.fromJson(json['recordList'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.recordList != null) {
      data['recordList'] = this.recordList!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class RecordList {
  int? id;
  String? body;
  String? createdAt;
  String? updatedAt;

  RecordList({this.id, this.body, this.createdAt, this.updatedAt});

  RecordList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
