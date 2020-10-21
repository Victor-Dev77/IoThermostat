import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/data/repository/user_repository.dart';
import 'package:iot_thermostat/app/translations/app_translations.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:location/location.dart';

class LocationService {
  static UserRepository _repository = UserRepository();

  static Future<Map<String, dynamic>> getLocation(
      {bool showDialogVerified: true}) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // Active Service Google
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    if (showDialogVerified) showDialogCheckLocation();
    Map<String, dynamic> map = {
      'latitude': _locationData.latitude,
      'longitude': _locationData.longitude,
    };
    return map;
  }

  static showDialogCheckLocation() async {
    Get.dialog(
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .25, vertical: Get.height * .35),
        child: Container(
          width: 150.0,
          height: 100.0,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "asset/auth/verified.jpg",
                height: 60,
                color: ConstantColor.colorAccent,
                colorBlendMode: BlendMode.color,
              ),
              SizedBox(height: 20),
              Text(
                AppTranslation.locationCheckTitle.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
    await Future.delayed(Duration(seconds: 2), () {
      if (Get.isDialogOpen) Get.back();
    });
  }

  static Future<Map<String, dynamic>> updateLocation(String idUser,
      {bool showDialogVerified: true}) async {
    Map<String, dynamic> _location = {};
    Map<String, dynamic> _coord =
        await getLocation(showDialogVerified: showDialogVerified);
    _location.addAll({"location": _coord});
    if (_location != null) {
      await _repository.updateUserLocation(idUser, _location);
    }
    return _coord;
  }
}
