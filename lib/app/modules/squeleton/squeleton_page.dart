import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:iot_thermostat/app/modules/add/add_room_page.dart';
import 'package:iot_thermostat/app/modules/rooms/schedule_room_page.dart';
import 'package:iot_thermostat/app/modules/settings/settings_page.dart';
import 'package:iot_thermostat/app/modules/squeleton/squeleton_controller.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';

class SqueletonPage extends GetView<SqueletonController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SqueletonController(),
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _pageWithIndex(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: ConstantColor.colorBackground,
            elevation: 0,
            selectedItemColor: ConstantColor.colorPrimary,
            unselectedItemColor: ConstantColor.grey,
            iconSize: 30,
            currentIndex: controller.indexMenu,
            onTap: (index) => controller.updateIndexMenu(index),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.timer), title: Text("schedule")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), title: Text("add")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text("settings")),
            ],
          ),
        );
      },
    );
  }

  Widget _pageWithIndex() {
    if (controller.indexMenu == 0)
      return ScheduleRoomPage();
    else if (controller.indexMenu == 1) return AddRoomPage();
    return SettingsPage();
  }
}
