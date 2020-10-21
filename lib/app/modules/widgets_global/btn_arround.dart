import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';

class BtnArround extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double width;
  final bool enabled;
  final Color colorEnabled, colorDisabled, textColor;
  final double fontSize;
  BtnArround({
    @required this.title,
    @required this.onTap,
    this.width,
    this.enabled: true,
    this.colorEnabled: ConstantColor.colorBackground,
    this.colorDisabled: ConstantColor.colorBackground60Opa,
    this.textColor: ConstantColor.white,
    this.fontSize: 18,
  }) : assert(title != null),
       assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    var newWidth = (width == null) ? Get.width - 100 : width;

    return SizedBox(
      height: 45,
      width: newWidth,
      child: MaterialButton(
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
          ),
        ),
        onPressed: () => enabled ? onTap() : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: enabled ? colorEnabled : colorDisabled,
        textColor: textColor,
        highlightElevation: 0.0,
        elevation: 0.0,
      ),
    );
  }
}
