import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:iot_thermostat/app/modules/widgets_global/bloc_info_temp.dart';
import 'package:iot_thermostat/app/utils/constant_color.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("IO'Thermostat"),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildTempRow(),
                _buildCircularSlider(),
                _buildTemp(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTempRow() {
    return Expanded(
      flex: 2,
      child: GetBuilder<MQTTController>(
        builder: (_) {
          if (!_.isConnecting || !_.thermostatConnected) return Container();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BlocInfoTemp(
                    icon: Icon(
                      FontAwesomeIcons.tint,
                      color: ConstantColor.primary,
                    ),
                    title: "Humidité",
                    value: "0.0%",          // Afficher l'humidité
                  ),
                  BlocInfoTemp(
                    icon: Icon(
                      FontAwesomeIcons.wind,
                      color: ConstantColor.primary,
                    ),
                    title: "Qualité Air",
                    // Fresh air = ppm < 500
                    // Good air = 501 < ppm < 700
                    // Air poor = ppm > 701
                    value: "Air poor",      // Afficher la qualité d'air
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircularSlider() {
    return Expanded(
      flex: 3,
      child: Container(
        width: Get.width,
        child: GetBuilder<MQTTController>(
          builder: (_) {
            if (!_.isConnecting)
              return Center(
                child: Text(
                  "Internet Indisponible...",
                  style: TextStyle(color: ConstantColor.primary, fontSize: 25),
                ),
              );
            if (!_.thermostatConnected)
              return Center(
                child: Text(
                  "Thermostat déconnecté...",
                  style: TextStyle(color: ConstantColor.primary, fontSize: 25),
                ),
              );
            return IgnorePointer(
              ignoring: !_.isConnecting,
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                    customColors: CustomSliderColors(
                  trackColor: ConstantColor.primaryBG,
                  progressBarColors: [
                    ConstantColor.accent,
                    Colors.red,
                    Colors.blue
                  ],
                )),
                min: 14,
                max: 30,
                initialValue: 14.0,                         // Aficher la température initiale
                onChange: (double value) => print(value),   // Modifier la température
                innerWidget: (value) {
                  int degree = value.round();
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$degree°C",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w400,
                        color: ConstantColor.primary,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTemp() {
    return GetBuilder<MQTTController>(
      builder: (_) {
        if (!_.isConnecting || !_.thermostatConnected) return Container();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            height: 75,
            width: 150,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ConstantColor.surface,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(
                    FontAwesomeIcons.thermometerHalf,
                    color: ConstantColor.primary,
                    size: 30,
                  ),
                ),
                Text(
                  "14.0°C",             // Afficher la température
                  style: TextStyle(
                    color: ConstantColor.primary,
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
