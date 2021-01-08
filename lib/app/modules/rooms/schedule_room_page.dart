import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/widgets_global/bloc_info_temp.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ScheduleRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildTempRow() {
    return Expanded(
      child: Padding(
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
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
              customColors: CustomSliderColors(
            trackColor: ConstantColor.primaryBG,
            progressBarColors: [ConstantColor.accent, Colors.red, Colors.blue],
          )),
          min: 14,
          max: 30,
          initialValue: 20,
          onChange: (double value) {
            //print(value);
          },
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
      ),
    );
  }

  Widget _buildMode() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Mode",
              style: TextStyle(
                color: ConstantColor.primaryBG,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 15),
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: ConstantColor.background,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1,
                        color: ConstantColor.primary.withOpacity(.5),
                      )
                    ]),
                child: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(FontAwesomeIcons.fire),
                      text: "ON",
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.snowflake),
                      text: "OFF",
                    ),
                  ],
                  labelColor: ConstantColor.primary,
                  unselectedLabelColor: ConstantColor.primaryBG,
                  indicator: RectangularIndicator(
                    color: ConstantColor.surface2x,
                    bottomLeftRadius: 100,
                    bottomRightRadius: 100,
                    topLeftRadius: 100,
                    topRightRadius: 100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
