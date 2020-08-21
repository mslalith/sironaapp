import 'package:flutter/material.dart';

class Person {
  String name;
  String phone;
  String email;
  String code;
  int refcount;

  Person(
      {@required this.name,
      @required this.phone,
      @required this.email,
      this.refcount,
      this.code});

  Person.fromJson(Map<String, dynamic> json)
      : name = json['NAME'],
        phone = json['PHONE'],
        email = json['EMAIL'],
        refcount = json['REFCOUNT'],
        code = json['CODE'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'phone': phone, 'email': email, 'code': code, 'refcount' : refcount};
}
