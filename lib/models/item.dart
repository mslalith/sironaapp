import 'package:flutter/material.dart';

class Item {
  int id;
  final String phone;
  final String orderId;
  final String desc;
  final int quantity;
  final String imageUrl1;
  final String imageUrl2;
  final String type;
  final int units;
  final double unitPrice;
  final double tax;
  final double amount;
  final String status;

Item({
  this.id,
  @required this.phone,
  @required this.orderId,
  @required this.desc,
  @required this.quantity,
  @required this.imageUrl1,
  @required this.imageUrl2,
  @required this.type,
  @required this. units,
  @required this.unitPrice,
  @required this.tax,
  @required this.amount,
  @required this.status
  });

Item.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        phone = json['PHONE'],
        orderId = json['ORDERID'],
        desc = json['DESCR'],
        quantity = json['QUANTITY'],
        imageUrl1 = json['IMAGEURL1'],
        imageUrl2 = json['IMAGEURL2'],
        unitPrice = json['UNITPRICE'] == null ? 0 : json['UNITPRICE'].toDouble(),
        units = json['UNITS'] == null ? 0 : json['UNITS'],
        type = json['TYPE'] == null ? 'N/A' : json['TYPE'],
        tax = json['TAX'] == null ? 0 : json['UNITPRICE'].toDouble(),
        amount = json['AMOUNT'] == null ? 0 : json['UNITPRICE'].toDouble(),
        status = json['STATUS'];
}