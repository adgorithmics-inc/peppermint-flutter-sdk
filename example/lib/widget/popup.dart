import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button.dart';

/// Pop-up widget to show error.
class Popup {
  Popup._();

  static Future<void> error(String message, {title, Function? callback}) async {
    await Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title ?? 'OOPS',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(message, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 20.0),
              const Divider(
                thickness: 0.5,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                    text: 'OK',
                    width: 200.0,
                    onTap: () {
                      Get.back();
                      if (callback != null) callback();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void popUp2Button(
    String message, {
    titleText,
    String? titleBtn1,
    String? titleBtn2,
    Function? btn1,
    Function? btn2,
    Widget? title,
    Widget? content,
  }) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              title ??
                  Text(
                    titleText ?? 'OOPS',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
              const SizedBox(height: 20.0),
              content ??
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(message, textAlign: TextAlign.center),
                  ),
              const SizedBox(height: 20.0),
              const Divider(
                thickness: 0.5,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MyButton(
                      text: titleBtn1 ?? 'OK',
                      onTap: () {
                        Get.back();
                        if (btn1 != null) btn1();
                      },
                      width: 200.0,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      text: titleBtn2 ?? 'CANCEL',
                      onTap: () {
                        if (btn2 != null) btn2();
                      },
                      width: 200.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void loading({bool dismissable = false}) {
    Get.dialog(
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const Center(
              child: CircularProgressIndicator(color: Colors.black)),
        ),
        barrierDismissible: dismissable);
  }

  static void pop() {
    Get.back();
  }
}
