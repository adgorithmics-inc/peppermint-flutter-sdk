import 'package:dio/dio.dart';

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
    if (res.data == null) {
      data = {};
    } else {
      data = res.data;
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

  void setData(Response res) {
    dynamic data;
    if (res.data == null || res.data.isEmpty) {
      data = {};
    } else {
      data = res.data;
    }

    this.data = data;
    errorMsg = '';
    response = res;
  }
}
