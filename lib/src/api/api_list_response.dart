import 'package:dio/dio.dart';

class ApiListResponse<T> {
  /// total data count wihout pagination
  int count;

  /// has next page to load
  bool hasNext;

  /// API data results
  List<T> results = [];

  String errorMsg;

  /// original API response
  late Response response;

  ApiListResponse({
    this.count = 0,
    this.hasNext = false,
    haveError,
    this.errorMsg = '',
    this.results = const [],
    required this.response,
  });

  factory ApiListResponse.fromJson(
      Response res, T Function(dynamic json) fromJsonData) {
    dynamic data;
    if (res.data == null) {
      data = {};
    } else {
      data = res.data;
    }
    return ApiListResponse(
      count: data['count'],
      hasNext: data['next'] != null,
      results: (data['results'] as List<dynamic>)
          .map((item) => fromJsonData(item))
          .toList(),
      response: res,
    );
  }
}
