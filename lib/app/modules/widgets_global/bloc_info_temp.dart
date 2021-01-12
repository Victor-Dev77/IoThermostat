import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iot_thermostat/app/utils/constant_color.dart';

class BlocInfoTemp extends StatelessWidget {
  final String title;
  final Icon icon;
  final String value;

  BlocInfoTemp(
      {@required this.title, @required this.icon, @required this.value})
      : assert(title != null && value != null && icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ConstantColor.surface,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          icon,
          SizedBox(),
          AutoSizeText(
            value,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(color: ConstantColor.primary, fontSize: 25),
          ),
          Text(
            title,
            style: TextStyle(color: ConstantColor.primary),
          ),
        ],
      ),
    );
  }
}
