import 'package:get/get.dart';
import 'package:iot_thermostat/app/services/mqtt_client.dart';

class MQTTController extends GetxController {

  static MQTTController get to => Get.find();

  RxInt _wifiValue = 0.obs;
  int get wifiValue => this._wifiValue.value;

  RxDouble _poidValue = 0.0.obs;
  double get poidValue => this._poidValue.value;

  int _intensityLocalisation = 1;
  int get intensityLocalisation => this._intensityLocalisation;

  String _textLocalisation = "Aucune connexion...";
  String get textLocalisation => this._textLocalisation;
  
  
  updateWifiSignal(String payload) {
    if(payload == "Je suis mort" || payload == "Je suis mort FLUTTER") {
      _wifiValue.value = 0;
    } else {
      _wifiValue.value = int.parse(payload).abs();
    }
    updateIntensity();
    //NotificationService.to.showNotif(_wifiValue.value);
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
    //Get.put(PoidsController());
   // Get.put(NotificationService());
  }

  updateIntensity() {
    //int value = 10 + Random().nextInt(91); // 10 a 90
    //print(value);
    if (_wifiValue.value == 0 || _wifiValue.value >= 90) {
      _intensityLocalisation = 0;
      _textLocalisation = "Aucune connexion...";
    }
    else if (_wifiValue.value >= 1 && _wifiValue.value <= 45) {
      _intensityLocalisation = 3;
      _textLocalisation = "Valise proche";
    }
    else if (_wifiValue.value > 45 && _wifiValue.value <= 54) {
      _intensityLocalisation = 2;
      _textLocalisation = "Valise éloignée";
    }
    else if (_wifiValue.value > 55 && _wifiValue.value < 90) {
      _intensityLocalisation = 1;
      _textLocalisation = "Valise hors de portée";
    }
    
  }

}