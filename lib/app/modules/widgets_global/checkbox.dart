import 'package:flutter/material.dart';
import 'package:iot_thermostat/app/utils/constant/constant_color.dart';

class CheckBoxCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final Color colorEnabled, colorDisabled, borderColorEnabled, borderColorDisabled;

  CheckBoxCustom(
      {@required this.onPressed,
      this.enabled: false,
      this.colorEnabled:
         ConstantColor.colorBackground, //colorBtnArroundEnabled, //colorBackground,
      this.colorDisabled: ConstantColor.white,
      this.borderColorEnabled: ConstantColor.black,
      this.borderColorDisabled: ConstantColor.grey});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: enabled ? borderColorEnabled : borderColorDisabled, width: 1),
          color: (enabled) ? colorEnabled : colorDisabled,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 3.0, // soften the shadow
              spreadRadius: 0.5, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                1.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
      ),
    );
  }
}
