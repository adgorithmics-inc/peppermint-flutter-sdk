import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_list_response.dart';
import 'api_response.dart';

const contentType = 'application/json; charset=UTF-8';

class WalletClient extends GetConnect {
  @override
  void onInit() async {
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.baseUrl = 'https://peppermint-api.dev';

    httpClient.addResponseModifier((request, response) {
      Get.log(
          'Wallet Api ${request.method}: ${request.url} : ${response.statusCode}');

      return response;
    });
    super.onInit();
  }

  Future<ApiResponse> postApi(
      {required String url,
      required body,
      Map<String, String>? headers}) async {
    Response response = await post(
      url,
      body,
      contentType: contentType,
      headers: headers,
    );
    if (response.status.hasError) {
      return ApiResponse(errorMsg: errorHandler(response));
    }
    return ApiResponse.fromResponse(response);
  }

  Future<ApiResponse> putApi({required String url, required body}) async {
    Response? response;
    response = await put(
      url,
      body,
      contentType: contentType,
    );
    if (response.status.hasError) {
      return ApiResponse(errorMsg: errorHandler(response));
    }
    return ApiResponse.fromResponse(response);
  }

  Future<ApiResponse> delApi({required String url}) async {
    Response? response;
    response = await delete(
      url,
      contentType: contentType,
    );
    if (response.status.hasError) {
      return ApiResponse(errorMsg: errorHandler(response));
    }
    return ApiResponse.fromResponse(response);
  }

  Future<dynamic> getApi(
      {required String url, param, bool list = false}) async {
    Response? response;
    response = await get(
      url,
      query: param,
      contentType: contentType,
    );
    if (response.status.hasError) {
      if (!response.status.connectionError) {}
      return list
          ? ApiListResponse(errorMsg: errorHandler(response))
          : ApiResponse(errorMsg: errorHandler(response), response: response);
    }
    return list
        ? ApiListResponse.fromResponse(response)
        : ApiResponse.fromResponse(response);
  }

  Future<ApiResponse> multipartApi({
    required String url,
    Map<String, dynamic>? body,
    File? file,
    String? fileKey = 'render',
  }) async {
    Map<String, dynamic> data = body ?? {};
    if (file != null) {
      data[fileKey!] = MultipartFile(
        file,
        filename: file.path,
        contentType: 'image/png',
      );
    }
    Response? response;
    response = await post(
      url,
      FormData(data),
      headers: {'Accept': '*/*'},
      contentType: 'multipart/form-data',
    );
    if (response.status.hasError) {
      return ApiResponse(errorMsg: errorHandler(response));
    }
    return ApiResponse.fromResponse(response);
  }

  http.StreamedResponse timeOutResponse({
    required String httpMethod,
    required dynamic error,
    required String url,
  }) {
    Map<String, dynamic> body = {'error': '$error'};
    int statusCode = 400;
    Uri destination = Uri.parse(url);
    String json = jsonEncode(body);
    return http.StreamedResponse(
      Stream.value(json.codeUnits),
      statusCode,
      request: http.Request(httpMethod, destination),
    );
  }

  String errorHandler(Response? response) {
    if (response == null) {
      return 'Something went wrong';
    }

    switch (response.statusCode) {
      case 400:
        final stringBuffer = StringBuffer();
        var data = response.body;
        data.forEach((key, value) {
          if (key == 'non_field_errors') {
            stringBuffer.writeln(value[0]);
          } else {
            stringBuffer.writeln('$value');
          }
        });
        return stringBuffer.toString();
      case 403:
        return 'Forbidden request';
      case 404:
        return 'Page does not exist';
      case 500:
        return 'Feature is under maintenance';
      default:
        return 'Something went wrong';
    }
  }
}
