import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class BasicDialog {
  static showExitAppDialog() {
    Get.defaultDialog(
      title: "Quitter",
      content: Text("Veux-tu quitter l'application?"),
      textCancel: "Non",
      onCancel: () => Get.back(),
      textConfirm: "Oui",
      onConfirm: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    );
  }
}
