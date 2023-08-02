import 'package:get/get.dart';

class ErrorHandlers {
  final String _wrong;
  final String _forbidden;
  final String _doesntExist;
  final String _underMaintenance;

  ErrorHandlers(
      {required String wrong,
      required String forbidden,
      required String doesntExist,
      required String underMaintenance})
      : _underMaintenance = underMaintenance,
        _doesntExist = doesntExist,
        _forbidden = forbidden,
        _wrong = wrong;

  String errorHandler(Response? response) {
    if (response == null) {
      return _wrong;
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
        return _forbidden;
      case 404:
        return _doesntExist;
      case 500:
        return _underMaintenance;
      default:
        return _wrong;
    }
  }
}
