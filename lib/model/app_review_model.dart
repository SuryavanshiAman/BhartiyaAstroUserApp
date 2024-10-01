
class AppReviewModel {
    AppReviewModel({
        required this.review,
        required this.profile,
        required this.name,
        required this.location,
    });

    String review;
    String profile;
    String name;
    String location;

    factory AppReviewModel.fromJson(Map<String, dynamic> json) => AppReviewModel(
        review: json["review"] ?? "",
        profile: json["profile"] ?? "",
        name: json["name"] ?? "",
        location: json["location"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "review": review,
        "profile": profile,
        "name": name,
        "location": location,
    };
}
