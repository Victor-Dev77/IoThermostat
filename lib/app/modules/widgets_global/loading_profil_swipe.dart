import 'package:flutter/material.dart';

class LoadingProfilSwipe extends StatefulWidget {
  @override
  _LoadingProfilSwipeState createState() => _LoadingProfilSwipeState();
}

class _LoadingProfilSwipeState extends State<LoadingProfilSwipe>
    with SingleTickerProviderStateMixin {
  bool isScanning = true;

  Animation<double> _scaleAnimation;
 /* Animation<double> _widthAnimation;
  Animation<double> _opacityAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _containerAnimation;*/
  AnimationController _scannerAnimationController;

  @override
  void initState() {
    super.initState();
    _scannerAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2500))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _scannerAnimationController.repeat();
             // _scannerAnimationController.reverse();
            }
          });
    _scaleAnimation =
        Tween(begin: 95.0, end: 275.0).animate(_scannerAnimationController);
   /* _widthAnimation =
        Tween(begin: 2.5, end: 10.0).animate(_scannerAnimationController);
    _opacityAnimation =
        Tween(begin: 1.0, end: 0.1).animate(_scannerAnimationController);
    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.lightBlue[100]).animate(
            CurvedAnimation(
                parent: _scannerAnimationController,
                curve: Interval(0.0, 0.6)));
    _containerAnimation = Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(
        parent: _scannerAnimationController, curve: Interval(0.6, 1.0)));*/
    _scannerAnimationController.forward();
  }

  @override
  void dispose() {
    _scannerAnimationController.dispose();
    _scannerAnimationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: _scaleAnimation.value,
            width: _scaleAnimation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x335D97F5),
              border: Border.all(
                color: Color(0x665D97F5),
                width: 3,//_widthAnimation.value,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            height: 90,
            width: 90,
            child: Image.asset("asset/icon_bomb.png"),
          ),
        ),
      ],
    );
  }
}
