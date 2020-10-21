import 'package:flutter/material.dart';
import 'package:iot_thermostat/app/utils/constant/constant_image.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 109,
          width: 100,
          child: Image.asset(
            ConstantImage.bomb,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
