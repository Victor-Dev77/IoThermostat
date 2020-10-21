import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'bindings/app_binding.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Name',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASHSCREEN,
      initialBinding: AppBinding(),
      theme: appThemeData,
      defaultTransition: Transition.fade,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      getPages: AppPages.routes,
      locale: Locale('fr', 'FR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppTranslation.languages,
      translationsKeys: AppTranslation.translations,
    );
  }
}

// Remove Scroll Overlay / Glow in List / Grid
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
