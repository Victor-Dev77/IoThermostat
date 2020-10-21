import 'package:flutter/material.dart';

class BlocInfoTemp extends StatelessWidget {
  final String title;
  final Icon icon;
  final int degree;

  BlocInfoTemp(
      {@required this.title, @required this.icon, @required this.degree})
      : assert(title != null && degree != null && icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          icon,
          Text(title),
          Text("$degree°"),
        ],
      ),
    );
  }
}
