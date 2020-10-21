import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';

class BackButtonAppBar extends AppBar {
  final Color iconColor, appBarColor;
  BackButtonAppBar(
      {this.appBarColor: ConstantColor.white,
      this.iconColor: ConstantColor.colorBackground})
      : super(
          elevation: 0,
          backgroundColor: appBarColor,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: iconColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        );
}
