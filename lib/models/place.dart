import 'package:flutter/material.dart';

class Place {
  final double latitude;
  final double longitude;
  final String address;

 const Place({
  @required this.latitude,
  @required this.longitude,
  @required this.address
}
);

}