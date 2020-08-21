import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:http/http.dart' as http;


class LocationList with ChangeNotifier {
  List<String> _locations = [];
  String authToken;
  String userId;


static const BACKURL = 'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com' ;

//static const BACKURL = 'http://10.0.2.2:3000';

  List<String> get getLocations {
     return [..._locations];
  }

  bool checkLocation(String loc) {
   return this._locations.contains(loc);
  } 

   set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

Future<void> fetchLocations() async {
  this._locations = [] ;
 
  final url = '$BACKURL/api/pins/getPins';

  try { print('came here to get locations - 2 : $url');
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': 'locations'})); 
       print(response);  
       final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['locations'];
     print(oData);
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
       this._locations.add(id['DESCR'])
        });
      print(this._locations);
      notifyListeners();
    } }
    catch(error) {
      throw (error);
      }}
}