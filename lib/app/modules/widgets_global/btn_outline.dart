import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';

class BtnOutline extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double width;
  final Color colorBorder, textColor;
  final TextStyle textStyle;
  BtnOutline({
    @required this.title,
    @required this.onTap,
    this.width,
    this.colorBorder: ConstantColor.white,
    this.textColor: ConstantColor.white,
    this.textStyle,
  })  : assert(title != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    var newWidth = (width == null) ? Get.width - 100 : width;
    var newTextStyle = (textStyle == null)
        ? TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          )
        : textStyle;
    var newTextColor = (textStyle == null) ? textColor : textStyle.color;

    return SizedBox(
      height: 45,
      width: newWidth,
      child: OutlineButton(
        child: Text(
          title,
          style: newTextStyle,
        ),
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textColor: newTextColor,
        color: ConstantColor.white,
        borderSide: BorderSide(color: colorBorder, width: 1.2),
        // highlightedBorderColor: ConstantColor.colorAccent,
        // highlightColor: ConstantColor.colorAccent,
      ),
    );
  }
}
