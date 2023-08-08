import 'package:dio/dio.dart';

import 'package:dio/io.dart';
import 'package:get/get.dart' as getx;
import 'package:sentry_flutter/sentry_flutter.dart';
// If in browser, import 'package:dio/browser.dart'.

class DioClient extends DioForNative {
  DioClient([BaseOptions? options]) : super(options) {
    /// We are appending https separately here because walletUrl is also used
    /// for websocket with prefix ws://
    super.options.baseUrl = 'https://peppermint-api.dev';
    super.options.connectTimeout = const Duration(seconds: 10);
    super.options.receiveTimeout = const Duration(seconds: 30);
    interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          reportError(e);
          return handler.next(e);
        },
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          getx.Get.log('API ${response.realUri.path} ${response.statusCode}: '
              '${response.statusMessage}\n');
          return handler.next(response);
        },
      ),
    );
  }

  void reportError(DioException e) {
    Sentry.captureEvent(
      SentryEvent(
        culprit:
            'API ${e.requestOptions.uri.toString()}: ${e.response?.statusCode}',
        message: SentryMessage('message: ${e.message}'),
      ),
    );
  }
}
