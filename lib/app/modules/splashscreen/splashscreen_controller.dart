import 'package:get/get.dart';
import 'package:iot_thermostat/app/data/model/user.dart';
import 'package:iot_thermostat/app/data/repository/user_repository.dart';
import 'package:iot_thermostat/app/modules/profil/user_controller.dart';
import 'package:iot_thermostat/app/routes/app_pages.dart';
import 'package:meta/meta.dart';

class SplashScreenController extends GetxController {
  final UserRepository repository;
  SplashScreenController({@required this.repository})
      : assert(repository != null);

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  _checkAuth() async {
    var userAuth = await repository.getCurrentUser();
    if (userAuth != null) {
      User user = await repository.getUser(userAuth.uid);
      if (user != null) {
        UserController.to.user = user;
        Get.offAllNamed(Routes.SQUELETON);
      } else
        Get.offAllNamed(Routes.AUTH);
    } else
      Get.offAllNamed(Routes.AUTH);
  }
}
