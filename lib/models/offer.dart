import 'package:flutter/material.dart';

class Offer {
  int offerid;
  final String code;
  final double disc;
  final String link;
  final String desc;
  final String startDate;
  final String endDate;

Offer({
  this.offerid,
  @required this.code,
  @required this.disc,
  @required this.link,
  @required this.desc,
  @required this.startDate,
  @required this.endDate
  });

Offer.fromJson(Map<String, dynamic> json)
      : offerid = json['ID'],
        code = json['CODE'],
        disc = json['DISC'].toDouble(),
        link = json['LINK'],
        desc = json['DESC'],
        startDate = json['START'],
        endDate = json['END'];

}