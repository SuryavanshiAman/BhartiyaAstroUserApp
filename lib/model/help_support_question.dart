class HelpSupportQuestionModel {
  HelpSupportQuestionModel({
    required this.id,
    required this.helpSupportId,
    required this.question,
    required this.answer,
    this.answers,
    this.isChatWithUs,
    this.isSubCategory,
  });

  int id;
  int helpSupportId;
  String question;
  String answer;
  List<Answer>? answers;
  int? isChatWithUs;
  bool? isSubCategory;

  factory HelpSupportQuestionModel.fromJson(Map<String, dynamic> json) => HelpSupportQuestionModel(
        id: json["id"],
        helpSupportId: json["helpSupportId"],
        question: json["question"],
        answer: json["answer"] ?? "",
        answers: json["answers"] != null ? List<Answer>.from(json["answers"].map((x) => Answer.fromMap(x))) : [],
        isChatWithUs: json["isChatWithUs"] ?? 0,
        isSubCategory: json["isSubCategory"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "helpSupportId": helpSupportId,
        "question": question,
        "answer": answer,
        "answers": List<dynamic>.from(answers!.map((x) => x.toMap())),
        "isChatWithUs": isChatWithUs ?? 0,
        "isSubCategory": isSubCategory ?? false,
      };
}

class Answer {
  Answer({this.answer, this.isChatWithUs});

  String? answer;
  int? isChatWithUs;

  factory Answer.fromMap(Map<String, dynamic> json) => Answer(
        answer: json["answer"],
        isChatWithUs: json["isChatWithUs"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "answer": answer,
        "isChatWithUs": isChatWithUs ?? 0,
      };
}
