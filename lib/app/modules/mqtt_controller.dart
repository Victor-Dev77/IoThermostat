import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/services/mqtt_client.dart';

import 'widgets_global/mode_switch.dart';

class MQTTController extends GetxController {

  static MQTTController get to => Get.find();

  static final tabKey = new GlobalKey<ModeSwitchState>();
  bool _starting = false;
  bool get isStarting => this._starting;

  double _temperature = 14.0;
  double get temperature => this._temperature;

  int _humidity = 0;
  int get humidity => this._humidity;

  String _airQuality = "Air poor";
  String get airQuality => this._airQuality;
  
  updateTemperature(String payload) {
    _temperature = double.parse(payload).abs();
    update();
  }

  updateHumidity(String payload) {
    _humidity = int.parse(payload).abs();
    update();
  }

  updateAirQuality(String payload) {
    _airQuality = payload;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    MQTTService.connect(); 
  }

  setStart() {
    _starting = true;
    tabKey.currentState.tabController.animateTo(0);
    update();
  }

  setDeath() {
    _starting = false;
    tabKey.currentState.tabController.animateTo(1);
    update();
  }

  changeMode(int index) {
    index == 0 ? setStart() : setDeath();
    MQTTService.publishOnOff(isStarting);
  }

}