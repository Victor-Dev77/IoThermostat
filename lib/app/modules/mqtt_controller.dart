import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/services/mqtt_client.dart';

import 'widgets_global/mode_switch.dart';

class MQTTController extends GetxController {

  static MQTTController get to => Get.find();

  static final tabKey = new GlobalKey<ModeSwitchState>();
  RxBool _startValue = false.obs;
  bool get isStarting => this._startValue.value;

  RxDouble _tempValue = 14.0.obs;
  double get tempValue => this._tempValue.value;

  RxDouble _poidValue = 0.0.obs;
  double get poidValue => this._poidValue.value;

  int _intensityLocalisation = 1;
  int get intensityLocalisation => this._intensityLocalisation;

  String _textLocalisation = "Aucune connexion...";
  String get textLocalisation => this._textLocalisation;
  
  
  updateTemperature(String payload) {
    _tempValue.value = double.parse(payload).abs();
    update();
  }

  updatePoids(String payload) {
    if(payload == "Je suis mort" || payload == "Je suis mort FLUTTER") {
      _poidValue.value = 0.0;
    } else {
      _poidValue.value = double.parse(payload);
    }
    //PoidsController.to.setPoids(_poidValue.value);
    //update(["poids"]);
  }

  @override
  void onInit() {
    super.onInit();
    MQTTService.connect(); 
  }

  setStart() {
    _startValue.value = true;
    tabKey.currentState.tabController.animateTo(0);
    update();
  }

  setDeath() {
    _startValue.value = false;
    tabKey.currentState.tabController.animateTo(1);
    update();
  }

  changeMode(int index) {
    index == 0 ? setStart() : setDeath();
    MQTTService.publishOnOff(isStarting);
  }

}