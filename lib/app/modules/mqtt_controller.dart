import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/widgets_global/my_check_internet.dart';
import 'package:iot_thermostat/app/modules/widgets_global/snackbar.dart';
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

  bool _isConnecting = false;
  bool get isConnecting => this._isConnecting;

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
    MyCheckInternet.instance.myStream.listen((value) {
      print("INTERNET => $value");
      if (!value.values.first) {
        // Pas internet
        Future.delayed(Duration(seconds: 2), () {
          CustomSnackbar.snackbar("Internet Indisponible");
          setDeath();
        });
        _isConnecting = false;
      } else {
        if (!_isConnecting) MQTTService.connect();
        _isConnecting = true;
        Future.delayed(Duration(seconds: 2), () {
          setStart();
        });
      }
    });
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
    if (_isConnecting) {
      index == 0 ? setStart() : setDeath();
      MQTTService.publishOnOff(isStarting);
    }
  }

  changeTemperature(double value) {
    _temperature = value;
    if (_isConnecting) MQTTService.publishTemperature(value.round());
  }
}
