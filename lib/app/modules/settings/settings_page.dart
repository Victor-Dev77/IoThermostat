import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/settings/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (_) {
        return RaisedButton(
            child: Text("Stop reading"), onPressed: () => print("cloc"));
      },
    );
  }
}
