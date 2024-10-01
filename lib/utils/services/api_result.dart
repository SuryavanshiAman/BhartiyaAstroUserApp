class APIResult<T> {
  String status;
  T recordList;

  APIResult({
    required this.status,
    required this.recordList,
  });

  factory APIResult.fromJson(Map<String, dynamic> json, T _recordList) =>
      new APIResult(
        status: json["status"].toString(),
        recordList: _recordList,
      );
}

// class Error {
//   String apiName;
//   String apiType;
//   String fileName;
//   dynamic functionName;
//   dynamic lineNumber;
//   dynamic typeName;
//   String stack;

//   Error({
//     this.apiName,
//     this.apiType,
//     this.fileName,
//     this.functionName,
//     this.lineNumber,
//     this.typeName,
//     this.stack,
//   });

//   factory Error.fromJson(Map<String, dynamic> json) => new Error(
//         apiName: json["apiName"],
//         apiType: json["apiType"],
//         fileName: json["fileName"],
//         functionName: json["functionName"],
//         lineNumber: json["lineNumber"],
//         typeName: json["typeName"],
//         stack: json["stack"],
//       );
//}
