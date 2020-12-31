import 'package:get/get.dart';

class ScheduleRoomController extends GetxController {

  static ScheduleRoomController get to => Get.find();

  bool isEnabled = false;

  @override
  void onInit() {
    super.onInit();

  }

  enabled() {
    isEnabled = true;
    update();
  }

  disabled() {
    isEnabled = false;
    update();
  }
  

}