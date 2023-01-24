import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button.dart';

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
}
