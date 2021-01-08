import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:iot_thermostat/app/modules/rooms/schedule_room_page.dart';
import 'package:iot_thermostat/app/modules/squeleton/squeleton_controller.dart';

class SqueletonPage extends GetView<SqueletonController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SqueletonController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text("IO'Thermostat"),
          ),
          body: SafeArea(
            child: ScheduleRoomPage(),
          ),
        );
      },
    );
  }
}
