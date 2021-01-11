import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../mqtt_controller.dart';

class ModeSwitch extends StatefulWidget {
  const ModeSwitch({Key key}) : super(key: key);
  @override
  ModeSwitchState createState() => ModeSwitchState();
}

class ModeSwitchState extends State<ModeSwitch> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
          GetBuilder<MQTTController>(
            builder: (_) {
              print("BUILD ON OFF -> ${_.isStarting}");
              return DefaultTabController(
                length: 2,
                initialIndex: _.isStarting ? 0 : 1,
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
                    controller: tabController,
                    onTap: (index) => _.changeMode(index),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
