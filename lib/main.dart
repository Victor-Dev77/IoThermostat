import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as Service;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Service.SystemChrome.setPreferredOrientations([Service.DeviceOrientation.portraitUp]);
  InAppPurchaseConnection.enablePendingPurchases();
  
  runApp(AppWidget());
}