import 'dart:core';

import 'package:flutter/material.dart';
class Order {
  String orderId;
  String name;
  String phone;
  String porder;
  String oDate;
  String oTime;
  String imageInd;
  double lat;
  double lng;
  String deliveryAddr;
  String delPerson;
  String status;
  double delCharge;
  String discCode;
  double discPerc;
  double amount;
  String eDate;
  String delContact;
  String pModified;
  String remarks;
  String mode;


Order({
  this.orderId,
  this.porder,
  @required this.name,
  @required this.phone,
  @required this.oDate,
  @required this.oTime,
  @required this.lat,
  @required this.lng,
  @required this.deliveryAddr,
  this.delPerson,
  this.imageInd,
  @required this.status,
  this.delCharge,
  this.discCode,
  this.discPerc,
  this.amount,
  this.eDate,
  this.delContact,
  this.pModified,
  this.remarks,
  this.mode
});

Order.fromJson(Map<String, dynamic> json)
      : orderId = json['ORDERID'],
        name = json['NAME'],
        phone = json['PHONE'],
        porder = json['PORDER'],
        oDate = json['ODATE'],
        oTime = json['OTIME'],
        lat = json['DLAT'].toDouble(),
        lng = json['DLNG'].toDouble(),
        imageInd = json['IMAGEIND'],
        deliveryAddr = json['DELADDR'],
        delPerson = json['DELPERSON'].trim() != '' ? json['DELPERSON'] : 'To be assigned',
        status = json['STATUS'],
        amount = json['PRICE'] != null ? json['PRICE'].toDouble() : null,
        eDate = json['EDATE'],
        delContact  = json['DELCONTACT'],
        delCharge = json['DELCHARGE'] != null ? json['DELCHARGE'].toDouble() : null,
        discPerc = json['DISCPERC']!= null ? json['DISCPERC'].toDouble() : null,
        discCode = json['DISCODE'],
        pModified = json['PMODIFIED'],
        remarks = json['REMARKS'],
        mode = json['MODE'];
}