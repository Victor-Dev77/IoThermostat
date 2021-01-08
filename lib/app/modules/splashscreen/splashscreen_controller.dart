import 'package:get/get.dart';
import 'package:iot_thermostat/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2), () => Get.offAllNamed(Routes.HOME));
  }
}
