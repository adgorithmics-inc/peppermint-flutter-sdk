import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseListController extends GetxController {
  bool loading = false;
  int page = 1;
  bool next = true;
  String error = '';

  /// Marked as Future<void> to be able to be used on [RefreshIndicator] widget.
  Future<void> resetPage() async {
    page = 1;
    getData();
  }

  void nextPage() {
    if (!next || loading) return;
    page++;
    getData();
  }

  void setLoading(bool value) {
    loading = value;
    if (loading) error = '';
    update();
  }

  @protected
  void getData() {}
}

class BaseDetailController extends GetxController {
  bool loading = false;
  String error = '';

  void setLoading(bool value) {
    loading = value;
    if (loading) error = '';
    update();
  }

  @protected
  void getData() {}
}
