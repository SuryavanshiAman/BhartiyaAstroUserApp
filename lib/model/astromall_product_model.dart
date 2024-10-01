class AstromallProductModel {
  AstromallProductModel({
    required this.id,
    required this.name,
    required this.features,
    required this.productImage,
    required this.productCategoryId,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.extraImages,
    this.questionAnswer,
    this.productReview,
  });

  int id;
  String name;
  String features;
  String productImage;
  int productCategoryId;
  int amount;
  String extraImages;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<QuestionAnswer>? questionAnswer;
  List<ProductReview?>? productReview;

  factory AstromallProductModel.fromJson(Map<String, dynamic> json) =>
      AstromallProductModel(
        id: json["id"],
        name: json["name"] ?? "",
        features: json["features"] ?? "",
        productImage: json["productImage"] ?? "",
        productCategoryId: json["productCategoryId"],
        amount: json["amount"],
        description: json["description"] ?? "",
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["updated_at"]),
        questionAnswer: json["questionAnswer"] != null
            ? List<QuestionAnswer>.from(
                json["questionAnswer"].map((x) => QuestionAnswer.fromMap(x)))
            : [],
        productReview: json["productReview"] == null
            ? []
            : List<ProductReview?>.from(
                json["productReview"]!.map((x) => ProductReview.fromMap(x))),
        extraImages: json["extraImages"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "features": features,
        "productImage": productImage,
        "productCategoryId": productCategoryId,
        "amount": amount,
        "extraImages": extraImages,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "questionAnswer":
            List<dynamic>.from(questionAnswer!.map((x) => x.toMap())),
        "productReview": productReview == null
            ? []
            : List<dynamic>.from(productReview!.map((x) => x!.toMap())),
      };
}

class QuestionAnswer {
  QuestionAnswer({
    this.question,
    this.answer,
    this.id,
  });

  String? question;
  String? answer;
  int? id;

  factory QuestionAnswer.fromMap(Map<String, dynamic> json) => QuestionAnswer(
        question: json["question"],
        answer: json["answer"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "question": question,
        "answer": answer,
        "id": id,
      };
}

class ProductReview {
  ProductReview({
    this.id,
    this.userId,
    this.rating,
    this.review,
    this.astrologerId,
    this.astromallProductId,
    this.reply,
    this.createdAt,
    this.updatedAt,
    this.isPublic,
    this.userName,
    this.profile,
  });

  int? id;
  int? userId;
  double? rating;
  String? review;
  dynamic astrologerId;
  int? astromallProductId;
  String? reply;
  DateTime? createdAt;
  DateTime? updatedAt;

  int? isPublic;
  dynamic userName;
  String? profile;

  factory ProductReview.fromMap(Map<String, dynamic> json) => ProductReview(
        id: json["id"],
        userId: json["userId"],
        rating: json["rating"].toDouble(),
        review: json["review"],
        astrologerId: json["astrologerId"],
        astromallProductId: json["astromallProductId"],
        reply: json["reply"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isPublic: json["isPublic"],
        userName: json["userName"] ?? "Unknown",
        profile: json["profile"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "rating": rating,
        "review": review,
        "astrologerId": astrologerId,
        "astromallProductId": astromallProductId,
        "reply": reply,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "isPublic": isPublic,
        "userName": userName,
        "profile": profile,
      };
}
