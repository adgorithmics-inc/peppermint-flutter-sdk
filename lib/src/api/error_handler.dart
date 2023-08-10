import 'package:dio/dio.dart';

extension ResponseExtension on DioException {
  String get errorMessage {
    String result = '';
    if (type == DioExceptionType.connectionError) {
      return "Connection error";
    } else if (response != null) {
      switch (response!.statusCode) {
        case 400:
          final stringBuffer = StringBuffer();
          var data = response!.data;
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
          return 'Seems like that page doesn\'t exist anymore';
        case 500:
          return 'Sorry, this service is under maintenance. You can try again later';
        default:
          return 'Something went wrong :( please try again later.';
      }
    } else {
      /// Something happened in setting up or sending the request that triggered an Error
      result = 'ERROR\n${requestOptions.uri.path.toString()}\n${toString()}';
    }
    return result;
  }
}
