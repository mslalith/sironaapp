import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_shop/models/offer.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:http/http.dart' as http;

class OfferList with ChangeNotifier {
  List<Offer> _offers = [];
  String authToken;
  String userId;
  Offer selectedOffer ;

 static const BACKURL = 'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com' ;
// static const BACKURL = 'http://10.0.2.2:3000';

  List<Offer> get getOffers {
     return [..._offers];
  }

  Offer getCoupon(String code) {

    Offer selected = new Offer(code: ' ', disc: 0, link: ' ', desc: ' ', startDate: ' ', endDate: ' ');
    this._offers.forEach((id) { 
      if(id.code == code) {
        selected = id;
      }
     });
    this .selectedOffer = selected;
    return selected;
  }

  void setOffer(Offer offer){
    this.selectedOffer = offer;
  }

  double getDisc() {
   return selectedOffer.disc;
  }
  
  Offer getOffer() {
    return selectedOffer ;
  }

  set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

Future<void> fetchOffers() async {  
  final url = '$BACKURL/api/offers/getOffers';
  try {
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': 'offers'}));   
       print(response);
       final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['offers'];
      this._offers = [];
      print(oData);
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
       this._offers.add(Offer.fromJson(id))
        });
      notifyListeners();
    } 
    }
    catch(error) {
      throw (error);
      }
}

}