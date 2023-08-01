import 'package:get/get.dart';

class ApiResponse<T> {
  T? data;
  String errorMsg;
  Response response;

  ApiResponse({
    this.data,
    required this.errorMsg,
    required this.response,
  });

  factory ApiResponse.fromResponse(Response res) {
    dynamic data;
    if (res.body == null) {
      data = {};
    } else {
      data = res.body;
    }

    return ApiResponse(
      data: data,
      errorMsg: '',
      response: res,
    );
  }

  factory ApiResponse.castResult(ApiResponse res, T data) {
    return ApiResponse(
      data: data,
      errorMsg: res.errorMsg,
      response: res.response,
    );
  }
}
