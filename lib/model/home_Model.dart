import 'dart:convert';

HomeModel welcomeFromMap(String str) => HomeModel.fromMap(json.decode(str));

String welcomeToMap(HomeModel data) => json.encode(data.toMap());

class HomeModel {
  HomeModel({
    this.banner,
    this.blog,
    this.productCategory,
    this.astrotalkInNews,
    this.astrologyVideo,
    required this.status,
    this.topOrders,
  });

  List<Banner>? banner;
  List<Blog>? blog;
  List<ProductCategory>? productCategory;
  List<AstrotalkInNews>? astrotalkInNews;
  List<AstrologyVideo>? astrologyVideo;
  List<TopOrder?>? topOrders;
  int status;

  factory HomeModel.fromMap(Map<String, dynamic> json) => HomeModel(
        banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
        blog: List<Blog>.from(json["blog"].map((x) => Blog.fromJson(x))),
        productCategory: List<ProductCategory>.from(json["productCategory"].map((x) => ProductCategory.fromJson(x))),
        astrotalkInNews: List<AstrotalkInNews>.from(json["astrotalkInNews"].map((x) => AstrotalkInNews.fromJson(x))),
        astrologyVideo: List<AstrologyVideo>.from(json["astrologyVideo"].map((x) => AstrologyVideo.fromJson(x))),
        status: json["status"],
        topOrders: json["topOrders"] == null ? [] : List<TopOrder?>.from(json["topOrders"]!.map((x) => TopOrder.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "banner": List<dynamic>.from(banner!.map((x) => x.toJson())),
        "blog": List<dynamic>.from(blog!.map((x) => x.toJson())),
        "productCategory": List<dynamic>.from(productCategory!.map((x) => x.toJson())),
        "astrotalkInNews": List<dynamic>.from(astrotalkInNews!.map((x) => x.toJson())),
        "astrologyVideo": List<dynamic>.from(astrologyVideo!.map((x) => x.toJson())),
        "status": status,
        "topOrders": topOrders == null ? [] : List<dynamic>.from(topOrders!.map((x) => x!.toMap())),
      };
}

class AstrologyVideo {
  AstrologyVideo({
    required this.id,
    required this.youtubeLink,
    required this.coverImage,
    required this.videoTitle,
    required this.createdAt,
  });

  int id;
  String youtubeLink;
  String coverImage;
  String videoTitle;
  String createdAt;

  factory AstrologyVideo.fromJson(Map<String, dynamic> json) => AstrologyVideo(
        id: json["id"],
        youtubeLink: json["youtubeLink"] ?? "",
        coverImage: json["coverImage"] ?? "",
        videoTitle: json["videoTitle"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {"id": id, "youtubeLink": youtubeLink, "coverImage": coverImage, "videoTitle": videoTitle, "created_at": createdAt};
}

class AstrotalkInNews {
  AstrotalkInNews({
    required this.id,
    required this.newsDate,
    required this.channel,
    required this.link,
    required this.bannerImage,
    required this.description,
  });

  int id;
  DateTime newsDate;
  String channel;
  String link;
  String bannerImage;
  String description;

  factory AstrotalkInNews.fromJson(Map<String, dynamic> json) => AstrotalkInNews(
        id: json["id"],
        newsDate: DateTime.parse(json["newsDate"]),
        channel: json["channel"] ?? "",
        link: json["link"] ?? "",
        bannerImage: json["bannerImage"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "newsDate": newsDate.toIso8601String(),
        "channel": channel,
        "link": link,
        "bannerImage": bannerImage,
        "description": description,
      };
}

class Banner {
  Banner({
    required this.id,
    required this.bannerImage,
    required this.fromDate,
    required this.toDate,
    required this.bannerType,
  });

  int id;
  String bannerImage;
  DateTime fromDate;
  DateTime toDate;
  String bannerType;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"],
        bannerImage: json["bannerImage"] ?? "",
        fromDate: DateTime.parse(json["fromDate"] ?? DateTime.now().toIso8601String()),
        toDate: DateTime.parse(json["toDate"] ?? DateTime.now().toIso8601String()),
        bannerType: json["bannerType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bannerImage": bannerImage,
        "fromDate": fromDate.toIso8601String(),
        "toDate": toDate.toIso8601String(),
        "bannerType": bannerType,
      };
}

class Blog {
  Blog({required this.id, required this.title, this.previewImage, required this.blogImage, this.blogCategoryId, this.description, required this.author, required this.viewer, required this.createdAt, this.extension});

  int id;
  String title;
  dynamic blogCategoryId;
  String? description;
  String author;
  String blogImage;
  int viewer;
  String? extension;
  String? previewImage;
  String createdAt;
  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"] ?? "",
        blogCategoryId: json["blogCategoryId"] ?? 0,
        description: json["description"] ?? "",
        author: json["author"] ?? "",
        blogImage: json["blogImage"] ?? "",
        viewer: json["viewer"] ?? 0,
        createdAt: json["created_at"],
        extension: json["extension"],
        previewImage: json["previewImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "blogCategoryId": blogCategoryId,
        "description": description,
        "author": author,
        "blogImage": blogImage,
        "viewer": viewer,
        "created_at": createdAt,
        "extension": extension,
        "previewImage": previewImage,
      };
}

class ProductCategory {
  ProductCategory({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.categoryImage,
  });

  int id;
  String name;
  int displayOrder;
  String categoryImage;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json["id"],
        name: json["name"] ?? "",
        displayOrder: json["displayOrder"] ?? "",
        categoryImage: json["categoryImage"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "displayOrder": displayOrder,
        "categoryImage": categoryImage,
      };
}

class TopOrder {
  TopOrder({this.id, this.userId, this.astrologerId, this.orderType, this.productCategoryId, this.productId, this.orderAddressId, this.payableAmount, this.walletBalanceDeducted, this.gstPercent, this.totalPayable, this.couponCode, this.paymentMethod, this.orderStatus, this.totalMin, this.createdAt, this.updatedAt, this.astrologerName, this.profileImage, this.chatId, this.callId, this.firebaseChatId});

  int? id;
  int? userId;
  int? astrologerId;
  String? orderType;
  dynamic productCategoryId;
  dynamic productId;
  dynamic orderAddressId;
  dynamic payableAmount;
  dynamic walletBalanceDeducted;
  dynamic gstPercent;
  String? totalPayable;
  dynamic couponCode;
  dynamic paymentMethod;
  String? orderStatus;
  String? totalMin;
  int? chatId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? astrologerName;
  String? firebaseChatId;
  dynamic profileImage;
  int? callId;

  factory TopOrder.fromJson(Map<String, dynamic> json) => TopOrder(
        id: json["id"],
        userId: json["userId"],
        astrologerId: json["astrologerId"],
        orderType: json["orderType"] ?? "",
        productCategoryId: json["productCategoryId"],
        productId: json["productId"],
        orderAddressId: json["orderAddressId"],
        payableAmount: json["payableAmount"],
        walletBalanceDeducted: json["walletBalanceDeducted"],
        gstPercent: json["gstPercent"] ?? 0,
        totalPayable: json["totalPayable"],
        couponCode: json["couponCode"],
        paymentMethod: json["paymentMethod"],
        orderStatus: json["orderStatus"],
        totalMin: json["totalMin"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        astrologerName: json["astrologerName"] ?? "",
        profileImage: json["profileImage"] ?? "",
        chatId: json["chatId"] ?? 0,
        callId: json["callId"] ?? 0,
        firebaseChatId: json["firebaseChatId"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "astrologerId": astrologerId,
        "orderType": orderType,
        "productCategoryId": productCategoryId,
        "productId": productId,
        "orderAddressId": orderAddressId,
        "payableAmount": payableAmount,
        "walletBalanceDeducted": walletBalanceDeducted,
        "gstPercent": gstPercent,
        "totalPayable": totalPayable,
        "couponCode": couponCode,
        "paymentMethod": paymentMethod,
        "orderStatus": orderStatus,
        "totalMin": totalMin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "astrologerName": astrologerName,
        "profileImage": profileImage,
        "chatId": chatId,
        "callId": callId,
        "firebaseChatId": firebaseChatId
      };
}
