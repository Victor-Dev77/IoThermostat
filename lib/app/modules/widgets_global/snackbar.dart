import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static snackbar(String text) {
    Get.snackbar(
      text,
      "",
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      // Text('$text ', style: TextStyle(fontWeight: FontWeight.bold),)
    );
  }
}
