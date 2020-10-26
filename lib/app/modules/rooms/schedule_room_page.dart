import 'package:flutter/material.dart';
import 'package:iot_thermostat/app/modules/widgets_global/bloc_info_temp.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ScheduleRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  }

  Widget _buildRoom() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Text("DROPDOWN ROOM"),
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
              Icons.ac_unit,
              color: ConstantColor.colorPrimary,
            ),
            title: "Cool at",
            degree: 80,
          ),
          BlocInfoTemp(
            icon: Icon(
              Icons.ac_unit,
              color: ConstantColor.colorAccent,
            ),
            title: "Heat at",
            degree: 80,
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
                    icon: Icon(Icons.ac_unit),
                    text: "ON",
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit),
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