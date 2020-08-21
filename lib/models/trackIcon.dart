import 'package:flutter/material.dart';

class TrackIcon extends StatelessWidget {
  final Color colorValue;
  TrackIcon({@required this.colorValue});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      width: 99,
      child: Image.asset(
        'lib/assets/images/logo.png',
        height: 25,
        color: colorValue,
      ),
    );
  }
}