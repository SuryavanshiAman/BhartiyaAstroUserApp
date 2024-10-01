class PalmRequets {
  int? astrologerID;
  String? name;
  String? dateOfBirth;
  String? birthPlace;
  String? birthTime;
  String? phone;
  String? address;
  String?attachment;
  String?leftHand;
  String?rightHand;
   //Left_hand Right_Hand
  PalmRequets(
      {this.astrologerID,
      this.name,
      this.dateOfBirth,
      this.birthPlace,
      this.birthTime,
      this.phone,
      this.address,
      this.attachment,
      this.leftHand,
      this.rightHand,
      });

  PalmRequets.fromJson(Map<String, dynamic> json) {
    astrologerID = json['astrologerID'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    birthPlace = json['birth_place'];
    birthTime = json['birth_time'];
    phone = json['phone'];
    address = json['address'];
    attachment  = json['attachment'];
    leftHand = json['left_hand'];
    leftHand = json['right_hand'];
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
    data['left_hand'] = this.leftHand;
    data['right_hand'] = this.rightHand;
    return data;
  }
}
