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

  bool _thermostatConnected = true;     //Remettre la valeur à false
  bool get thermostatConnected => this._thermostatConnected;

  updateTemperature(String payload) {
    ;         // Convertir le type String en double + mettre à jour la température et la connexion du thermostat
    update();
  }

  updateHumidity(String payload) {
    ;         // Convertir le type String en double + mettre à jour l'humidité et la connexion du thermostat
    update();
  }

  updateAirQuality(String payload) {
    ;         // Mettre à jour la qualité de l'air et la connexion du thermostat
    update();
  }
  
  updateThermostatConnecting(bool value) {
    ;         // Mettre à jour la connexion du thermostat
    update();
  }

  changeTemperature(double value) {
    ;     // Mettre à jour la température de la roulette et envoyer la température au broker MQTT si il est connecté
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
        //if (!_isConnecting) MQTTService.connect();    //Decommenter cette ligne
        _isConnecting = true;
      }
      update();
    });
  }
}


