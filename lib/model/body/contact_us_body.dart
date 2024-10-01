class ContactUsBody {
  String? name;
  String? phone;
  String? email;
  String? message;
  String? subject;

  ContactUsBody({this.name, this.phone, this.email, this.message,this.subject});

  ContactUsBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    message = json['message'];
    subject  = json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['message'] = this.message;
    data['subject'] = this.subject;
    return data;
  }
}
