class ReviewModel {
  ReviewModel({
    this.id,
    required this.name,
    required this.userId,
    required this.rating,
    required this.review,
    required this.astrologerId,
    required this.astromallProductId,
    required this.reply,
    required this.updatedAt,
    required this.profile,
    required this.isPublic,
  });
  int? id;
  int userId;
  String name;
  double rating;
  String review;
  int astrologerId;
  int astromallProductId;
  String reply;
  DateTime updatedAt;
  String profile;
  int isPublic;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        name: json["name"] ?? "",
        userId: json["userId"] ?? "",
        rating: json["rating"] != null ? double.parse(json["rating"].toString()) : 0,
        review: json["review"] ?? "",
        astrologerId: json["astrologerId"] ?? "",
        astromallProductId: json["astromallProductId"] ?? 0,
        reply: json["reply"] ?? "",
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        profile: json["profile"] ?? "",
        isPublic: json["isPublic"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userId": userId,
        "rating": rating,
        "review": review,
        "astrologerId": astrologerId,
        "astromallProductId": astromallProductId,
        "reply": reply,
        "updated_at": updatedAt.toIso8601String(),
        "profile": profile,
        "isPublic": isPublic,
      };
}
