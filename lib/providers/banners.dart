import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:http/http.dart' as http;

class BannerList with ChangeNotifier {
  List<String> _banners = [];
  String authToken;
  String userId;
  bool _imagesLoaded = false;



static const BACKURL = 'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com' ;
//static const BACKURL = 'http://10.0.2.2:3000';

  List<String> get getBanners {
     return [..._banners];
  }

  bool get imagesLoaded {
    return  _imagesLoaded;
  }


  set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

Future<void> fetchBanners() async {  
  final url = '$BACKURL/api/banners/getBanners';
    this._imagesLoaded = false;
  try {
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': 'banners'}));   
       print(response);
       final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['banners'];
      this._banners = [];
      print(oData);
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
       this._banners.add(id['DESCR'])
        });
      this._imagesLoaded = true;
      notifyListeners();
    } 
    }
    catch(error) {
      throw (error);
      }
}

}