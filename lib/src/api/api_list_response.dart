import 'package:get/get.dart';

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

  factory ApiListResponse.fromResponse(Response res) {
    dynamic data;
    if (res.body == null) {
      data = {};
    } else {
      data = res.body;
    }

    return ApiListResponse(
      count: data['count'],
      hasNext: data['next'] != null,
      results: data['results'],
      response: res,
    );
  }

  /// shouldn't be called unless result success
  factory ApiListResponse.castResult(ApiListResponse res, List<T> data) {
    return ApiListResponse(
      count: res.count,
      hasNext: res.hasNext,
      errorMsg: res.errorMsg,
      results: data,
      response: res.response,
    );
  }
}
