import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:http/http.dart' as http;

class UnitList with ChangeNotifier {
  List<String> _units = [];
  String authToken;
  String userId;

static const BACKURL = 'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com' ;
//static const BACKURL = 'http://10.0.2.2:3000';

  List<String> get getUnits {
    print(_units);
     return [..._units];
  }

  bool checkLocation(String loc) {
   return this._units.contains(loc);
  } 

  set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

Future<void> fetchUnits() async {
  final url = '$BACKURL/api/units/getUnits';

  try {
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': 'UNITS'}));   
       final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['units'];
     this._units = [];
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
       this._units.add(id['DESCR'])
        });
      notifyListeners();
    } 
    }
    catch(error) {
      throw (error);
      }
}

}