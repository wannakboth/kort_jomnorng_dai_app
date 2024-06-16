import 'search_model.dart';

class ApiResponse {
  final Data data;
  final int errorCode;
  final String status;

  ApiResponse(
      {required this.data, required this.errorCode, required this.status});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: Data.fromJson(json['data'] ?? []),
      errorCode: json['errorCode'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'errorCode': errorCode,
      'status': status,
    };
  }
}
