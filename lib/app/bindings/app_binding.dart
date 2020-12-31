import 'package:get/get.dart';
import 'package:iot_thermostat/app/data/repository/user_repository.dart';
import 'package:iot_thermostat/app/modules/profil/user_controller.dart';
import 'package:iot_thermostat/app/modules/rooms/schedule_room_controller.dart';
import 'package:iot_thermostat/app/modules/splashscreen/splashscreen_controller.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController(repository: UserRepository()));
    Get.put(UserController(repository: UserRepository()));
    Get.put(ScheduleRoomController(), permanent: true);
  }
}