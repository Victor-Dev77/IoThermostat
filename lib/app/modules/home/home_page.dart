import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/mqtt_controller.dart';
import 'package:iot_thermostat/app/modules/widgets_global/bloc_info_temp.dart';
import 'package:iot_thermostat/app/modules/widgets_global/mode_switch.dart';
import 'package:iot_thermostat/app/services/mqtt_client.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildTempRow(),
                _buildCircularSlider(),
                _buildMode(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTempRow() {
    return Expanded(
      child: GetBuilder<MQTTController>(
        builder: (_) {
          if (!_.isStarting)
            return Container();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BlocInfoTemp(
                    icon: Icon(
                      FontAwesomeIcons.tint,
                      color: ConstantColor.primary,
                    ),
                    title: "Humidité",
                    value: "80%",
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
                    value: "Air poor",
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
      flex: 2,
      child: Container(
        width: Get.width, //275,
        //  height: 275,
        //color: Colors.green,
        child: GetBuilder<MQTTController>(
          builder: (_) {
            if (!_.isStarting) return Container();
            return SleekCircularSlider(
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
              initialValue: _.tempValue,
              onChange: (double value) => MQTTService.publishTemperature(value),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildMode() {
    return Expanded(flex: 1, child: ModeSwitch(key: MQTTController.tabKey));
  }
}
