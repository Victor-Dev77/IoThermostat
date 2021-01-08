import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:iot_thermostat/app/modules/splashscreen/splashscreen_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
    Get.put(MQTTController());
  }
}