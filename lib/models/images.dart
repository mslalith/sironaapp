import 'package:flutter/material.dart';

class Imageinfo {
  int imageId;
  final String phone;
  final int orderId;
  final String imageUrl;

Imageinfo({
  this.imageId,
  @required this.phone,
  @required this.orderId,
  @required this.imageUrl
  });

Imageinfo.fromJson(Map<String, dynamic> json)
      : imageId = json['IMAGEID'],
        phone = json['PHONE'],
        orderId = json['ORDERID'],
        imageUrl = json['IMAGEURL'];

}