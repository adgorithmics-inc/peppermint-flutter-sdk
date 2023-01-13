import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loading.dart';

class Popup {
  Popup._();

  static void loading({bool dismissable = false}) {
    Get.dialog(
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const PeppermintLoading(),
        ),
        barrierDismissible: dismissable);
  }

  static void pop() {
    Get.back();
  }
}
