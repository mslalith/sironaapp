import 'package:flutter/material.dart';

class PAddress {
  int addrid;
  final String id;
  final String name;
  final String phone;
  final String label;
  final String address;
  final String pincode;
  final double lat;
  final double lng;

PAddress({
  @required this.id,
  @required this.name,
  @required this.phone,
  @required this.label,
  @required this.address,
  @required this.pincode,
  @required this.lat,
  @required this.lng
  });

PAddress.fromJson(Map<String, dynamic> json)
      : id = json['ID'], 
        addrid = json['ADDRID'].toInt(), 
        name = json['NAME'],
        phone = json['PHONE'],
        label = json['LABEL'],
        address = json['ADDRESS'],
        pincode = json['PINCODE'] == null ? json['PINCODE'] : ' ',
        lat = json['LAT'],
        lng = json['LNG'];
}