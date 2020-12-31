import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/squeleton/squeleton_controller.dart';
import 'package:iot_thermostat/app/modules/widgets_global/snackbar.dart';
import 'package:iot_thermostat/app/utils/functions.dart';

class AddRoomController extends GetxController {

  static AddRoomController get to => Get.find();

  TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  addRoom() {
    String room = nameController.text.trim();
    var length = room.length;
    if ((length < 3 && length != 0) || length > 30) {
      CustomSnackbar.snackbar("La pièce doit contenir entre 3 et 30 caractères");
    } else if (length > 0) {
      room = capitalizeFirstLetter(room);
      SqueletonController.to.addRoom(room);
    }
    nameController.clear();
    update();
  }

}