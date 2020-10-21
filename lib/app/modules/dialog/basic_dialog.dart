import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/data/repository/user_repository.dart';
import 'package:iot_thermostat/app/routes/app_pages.dart';

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

  static showLogoutDialog() {
    Get.defaultDialog(
      title: "Déconnexion",
      content: Text("Voulez-vous vous déconnecter de votre compte ?"),
      textCancel: "Non",
      onCancel: () => Get.back(),
      textConfirm: "Oui",
      onConfirm: () async {
        await UserRepository().logout();
        Get.offAllNamed(Routes.AUTH);
      },
    );
  }
}
