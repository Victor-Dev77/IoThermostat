import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:iot_thermostat/app/modules/splashscreen/splashscreen_controller.dart';
import 'package:iot_thermostat/app/modules/widgets_global/my_check_internet.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
    Get.put(MQTTController());
    MyCheckInternet.instance.initialise();
  }
}