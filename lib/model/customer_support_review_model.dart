class CustomerSupportReviewModel {
  CustomerSupportReviewModel({
    this.id,
    this.review,
    this.rating,
    this.ticketId,
    this.userId,
  });

  int? id;
  String? review;
  double? rating;
  int? ticketId;
  int? userId;

  factory CustomerSupportReviewModel.fromJson(Map<String, dynamic> json) => CustomerSupportReviewModel(
        id: json["id"],
        review: json["review"],
        rating: double.parse(json["rating"].toString()),
        ticketId: json["ticketId"],
        userId: json["userId"],
      );

  Map<String, dynamic> tojson() => {
        "id": id,
        "review": review,
        "rating": rating,
        "ticketId": ticketId,
        "userId": userId,
      };
}
