import 'package:get/get.dart';

import 'api_response.dart';

class ApiListResponse extends ApiResponse {
  int? count;
  String? next;
  String? previous;
  List<dynamic>? results;

  ApiListResponse({
    haveError,
    errorMsg,
  }) : super(errorMsg: errorMsg);

  ApiListResponse.fromResponse(Response res) : super(errorMsg: '') {
    super.setData(res);
    count = super.data['count'];
    next = super.data['next'];
    previous = super.data['previous'];
    results = super.data['results'];
  }
}
