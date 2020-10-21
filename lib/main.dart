import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as Service;
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Service.SystemChrome.setPreferredOrientations([Service.DeviceOrientation.portraitUp]);
  
  runApp(AppWidget());
}