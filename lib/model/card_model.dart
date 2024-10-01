class CardModel {
  int? id;
  String? name;
  String? number;
  int? expiryMonth;
  int? expiryYear;
  String? cvv;

  CardModel({this.id, this.number, this.name, this.expiryMonth, this.expiryYear, this.cvv});

  CardModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'] != null ? map['name'] : '';
    number = map['last4'] != null ? map['last4'] : '';
    expiryMonth = map['exp_month'] != null ? map['exp_month'] : null;
    expiryYear = map['exp_year'] != null ? map['exp_year'] : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
    };
  }
}
