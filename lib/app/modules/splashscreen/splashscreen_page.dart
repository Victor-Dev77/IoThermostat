import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 109,
          width: 100,
          child: Image.asset(
            "assets/icon.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
