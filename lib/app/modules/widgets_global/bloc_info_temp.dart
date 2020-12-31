import 'package:flutter/material.dart';

class BlocInfoTemp extends StatelessWidget {
  final String title;
  final Icon icon;
  final int percent;

  BlocInfoTemp(
      {@required this.title, @required this.icon, @required this.percent})
      : assert(title != null && percent != null && icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          icon,
          Text("$percent°"),
          Text(title),
        ],
      ),
    );
  }
}
