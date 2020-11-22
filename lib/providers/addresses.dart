import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_shop/models/address.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:http/http.dart' as http;

class AddressList with ChangeNotifier {
  List<PAddress> _address = [];
  bool get hasAddress => _address.length != 0;
  PAddress _baseAddress;
  bool queryFinished = false;
  String authToken;
  String userId;

  static const BACKURL =
      'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com';

// static const BACKURL = 'http://10.0.2.2:3000';

  List<PAddress> get getAddresses {
    return [..._address];
  }

  PAddress get baseAddress {
    return _baseAddress;
  }

  bool checkAddress() {
    if (this._address.length == 0) {
      if (this.queryFinished) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  set auth(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchAddress(String number) async {
    this._address = [];
    print('came here to fetch addresses');
    final url = '$BACKURL/api/addr/getAddresses';
    try {
      print('came here to fetch addresses-1');
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'phone': number}));
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      print('came here to fetch addresses-2');
      List oData = userMap['address'];
      this.queryFinished = true;
      print(oData);
      if (oData == null) {
      } else {
        if (oData.isNotEmpty) {
          oData.forEach((id) => {
                //print(id)
                this._address.add(PAddress.fromJson(id))
              });
          this._baseAddress = this._address[0];
        }
        notifyListeners();
      }
    } catch (error) {
      this.queryFinished = true;
      throw (error);
    }
  }

  Future<void> delAddress(PAddress delAddr) async {
    final url = '$BACKURL/api/addr/delAddress';
    print("Id is + ${delAddr.addrid}");
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'ADDRID': delAddr.addrid}));
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      var oData = userMap['message'];
      if (oData == null) {
      } else {
        var index = this._address.indexOf(delAddr);
        this._address.removeAt(index);
        notifyListeners();
      }
    } catch (error) {
      this.queryFinished = true;
      throw (error);
    }
  }

  Future<void> putAddress(PAddress newAddress) async {
    final url = '$BACKURL/api/addr/putAddress';
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id': newAddress.id,
          'name': newAddress.name,
          'phone': newAddress.phone,
          'address': newAddress.address,
          'lat': newAddress.lat,
          'long': newAddress.lng,
          'label': newAddress.label,
          'pincode': newAddress.pincode
        }));
    print('response: $response');
    this._address.add(newAddress);
    var udata = json.decode(response.body);
    notifyListeners();
  }

  Future<void> updAddress(PAddress newAddress) async {
    final url = '$BACKURL/api/addr/updAddress';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'addrid': newAddress.addrid,
            'id': newAddress.id,
            'name': newAddress.name,
            'phone': newAddress.phone,
            'address': newAddress.address,
            'lat': newAddress.lat,
            'long': newAddress.lng,
            'label': newAddress.label,
            'pincode': newAddress.pincode
          }));
      var index =
          this._address.indexWhere((id) => id.addrid == newAddress.addrid);
      this._address[index] = newAddress;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
