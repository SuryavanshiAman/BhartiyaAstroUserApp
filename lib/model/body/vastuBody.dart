class VastuBody {
  int? astrologerID;
  String? name;
  String? dateOfBirth;
  String? birthPlace;
  String? birthTime;
  String? phone;
  String? address;
  String? attachment;
  String?location;

  VastuBody(
      {this.astrologerID,
      this.name,
      this.dateOfBirth,
      this.birthPlace,
      this.birthTime,
      this.phone,
      this.address,
      this.attachment,
      this.location
      
      });

  VastuBody.fromJson(Map<String, dynamic> json) {
    astrologerID = json['astrologerID'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    birthPlace = json['birth_place'];
    birthTime = json['birth_time'];
    phone = json['phone'];
    address = json['address'];
    attachment = json['attachment'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['astrologerID'] = this.astrologerID;
    data['name'] = this.name;
    data['date_of_birth'] = this.dateOfBirth;
    data['birth_place'] = this.birthPlace;
    data['birth_time'] = this.birthTime;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['attachment'] = this.attachment;
    data['location']  = this.location;
    return data;
  }
}
