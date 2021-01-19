import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/widgets_global/my_check_internet.dart';
import 'package:iot_thermostat/app/modules/widgets_global/snackbar.dart';
import 'package:iot_thermostat/app/services/mqtt_client.dart';

class MQTTController extends GetxController {
  static MQTTController get to => Get.find();

  double _temperature = 14.0;
  double get temperature => this._temperature;

  double _initialTemperature = 0;
  double get initialTemperature => this._initialTemperature;

  double _humidity = 0;
  double get humidity => this._humidity;

  String _airQuality = "Air poor";
  String get airQuality => this._airQuality;

  bool _isConnecting = false;
  bool get isConnecting => this._isConnecting;

  bool _thermostatConnected = true;
  bool get thermostatConnected => this._thermostatConnected;

  updateTemperature(String payload) {
    _temperature = double.parse(payload).abs();
    if (_initialTemperature == 0)
      _initialTemperature = _temperature;
    updateThermostatConnecting(true);
    update();
  }

  updateHumidity(String payload) {
    _humidity = double.parse(payload).abs();
    updateThermostatConnecting(true);
    update();
  }

  updateAirQuality(String payload) {
    _airQuality = payload;
    updateThermostatConnecting(true);
    update();
  }
  
  updateThermostatConnecting(bool value) {
    _thermostatConnected = value;
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
        });
        _isConnecting = false;
      } else {
        if (!_isConnecting) MQTTService.connect();
        _isConnecting = true;
      }
      update();
    });
  }

  changeTemperature(double value) {
    _initialTemperature = value;
    if (_isConnecting) MQTTService.publishTemperature(value.round());
  }
}
