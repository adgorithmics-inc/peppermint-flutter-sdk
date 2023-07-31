import 'package:get/get.dart';

class ApiResponse {
  dynamic data;
  String errorMsg;
  Response? response;

  ApiResponse({
    this.data,
    required this.errorMsg,
    this.response,
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

  void setData(Response res) {
    dynamic data;
    if (res.body == null || res.body.isEmpty) {
      data = {};
    } else {
      data = res.body;
    }

    this.data = data;
    errorMsg = '';
    response = res;
  }
}
