import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/home/home_page.dart';
import 'package:iot_thermostat/app/modules/splashscreen/splashscreen_page.dart';
part './app_routes.dart';


class AppPages {
  
  static final routes = [
    GetPage(name: Routes.SPLASHSCREEN, page: () => SplashScreenPage(),),
    GetPage(name: Routes.SQUELETON, page: () => HomePage()),
    GetPage(name: Routes.AUTH, page: () => HomePage()),
  ];
}