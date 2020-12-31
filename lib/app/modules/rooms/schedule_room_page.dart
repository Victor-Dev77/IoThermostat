import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/rooms/schedule_room_controller.dart';
import 'package:iot_thermostat/app/modules/squeleton/squeleton_controller.dart';
import 'package:iot_thermostat/app/modules/widgets_global/bloc_info_temp.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:iot_thermostat/app/modules/widgets_global/custom_dropdown.dart'
    as custom;

class ScheduleRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleRoomController>(
      builder: (_) {
        if (_.isEnabled)
          return Center(
            child: Column(
              children: <Widget>[
                _buildRoom(),
                _buildTempRow(),
                _buildCircularSlider(),
                _buildMode(),
              ],
            ),
          );
        return Center(
          child: Text(
            "Veuillez ajouter une pièce\nde votre maison",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoom() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: GetBuilder<SqueletonController>(
        builder: (_) {
          return Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "Pièce ${_.rankRoom}/${_.nbRooms}",
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: custom.DropdownButtonFormField(
                    items: _.rooms.map((String value) {
                      return custom.DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => _.changeRoom(value),
                    height: _.nbRooms > 4 ? 200.0 : null,
                    offsetAmount: 150.0,
                    value: _.roomSelected,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTempRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BlocInfoTemp(
            icon: Icon(
              FontAwesomeIcons.tint,
              color: ConstantColor.colorPrimary,
            ),
            title: "Humidité",
            percent: 80,
          ),
          BlocInfoTemp(
            icon: Icon(
              FontAwesomeIcons.wind,
              color: ConstantColor.colorAccent,
            ),
            title: "Qualité Air",
            percent: 65,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularSlider() {
    return Container(
      width: 275,
      height: 275,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(),
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
              "$degree°",
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMode() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Mode",
            style: TextStyle(
              color: ConstantColor.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
                  gradient: LinearGradient(
                    colors: [
                      ConstantColor.white.withOpacity(.5),
                      ConstantColor.white,
                      ConstantColor.white.withOpacity(.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 5,
                        color: ConstantColor.grey.withOpacity(.5),
                        offset: Offset(0, 10))
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
                labelColor: ConstantColor.white,
                unselectedLabelColor: ConstantColor.grey,
                indicator: RectangularIndicator(
                  color: ConstantColor.colorPrimary,
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
    );
  }
}
