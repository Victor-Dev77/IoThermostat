import 'package:flutter/material.dart';
import 'package:iot_thermostat/app/modules/widgets_global/bloc_info_temp.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              _buildFanMode(),
              _buildTempRow(),
              _buildCircularSlider(),
              _buildHVACMode(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: ConstantColor.colorBackground,
        elevation: 0,
        selectedItemColor: ConstantColor.colorPrimary,
        unselectedItemColor: ConstantColor.grey,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.timer), title: Text("add")),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("add")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("settings")),
        ],
      ),
    );
  }

  Widget _buildFanMode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Fan Mode"),
          ],
        ),
        Switch(
          onChanged: (value) => print(value),
          value: true,
        ),
      ],
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
          print(value);
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

  Widget _buildHVACMode() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            "HVAC Mode",
            style: TextStyle(
              color: ConstantColor.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          DefaultTabController(
            length: 4,
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
                    text: "Heat",
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit),
                    text: "Cool",
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit),
                    text: "Auto",
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit),
                    text: "Off",
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
