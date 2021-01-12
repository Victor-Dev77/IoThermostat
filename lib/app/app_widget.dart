import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'bindings/app_binding.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "IO'Thermostat",
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASHSCREEN,
      initialBinding: AppBinding(),
      theme: appThemeData,
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      locale: Locale('fr', 'FR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}