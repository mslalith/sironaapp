import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:medical_shop/models/images.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:medical_shop/providers/auth.dart';

class OrderList with ChangeNotifier {
  List<Order> _orders = [];
  List<Item> _items = [];
  List<Imageinfo> _images = [];
  String authToken;
  String userId;
  bool orderPlaced = false;
  String orderId = '';

  bool getOrderStatus() {
    return orderPlaced;
  }

  String getOrderId() {
    return orderId;
  }

 static const BACKURL = 'http://Sirona-env.eba-zb3yegkm.ap-south-1.elasticbeanstalk.com' ;
// static const BACKURL = 'http://10.0.2.2:3000';

  set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }
     
  List<Item> get getItems {
     return [..._items];
  } 

  List<String> get iOrders {
    List<String> iUrls = [];
    _orders.forEach((id) {
      if(id.imageInd == 'YES') {
        _items.forEach((iId) { 
          if(iId.orderId == id.orderId){
            if(iId.imageUrl1.length > 10) {
              iUrls.add(iId.imageUrl1);
            }
            if(iId.imageUrl2.length > 10) {
              iUrls.add(iId.imageUrl2);
            }
          }
        });
      }
     });
     return iUrls;
  }

  List<Imageinfo> get getImages {
     return [..._images];
  } 

  List<Order> get getOrders {
     return [..._orders];
  } 

  List<Item> getIts(Order oid) {
    List<Item> oItems = [];

    for(var i=0 ; i < _items.length ; i ++) {
      Item id =_items[i];
      if(id.orderId == oid.orderId) {
          oItems.add(id);
      }
    }
    return oItems;
  }

Future<void> fetchItems(String number) async {
  this._items = [] ;
    
    final url = '$BACKURL/api/items/getItems';

    try {
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': number}));   
  final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['profile'];
      print(oData);
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
       // print(id)
          this._items.add(Item.fromJson(id))
        });
        print(_items.length);
        notifyListeners();
    } 
    }
    catch(error) {
      throw (error);
      }
    
  }
  
  
  Future<void> fetchImages(String number) async {
  this._images = [] ;
    
    final url = '$BACKURL/api/images/getImages';
 
    try {
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': number}));   
  final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['profile'];
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
       print(id) 
       // this._orders.add(Order.fromJson(id))
        });
        notifyListeners();
    } 
    }
    catch(error) {
      throw (error);
      }
    
  }
    
Future<void> fetchOrders(String number) async {
  this._orders = [] ;
  print('fetching orders');
    
    final url = '$BACKURL/api/orders/getOrders';

    try {
      final response = await http.post(url, 
       headers: {"Content-Type": "application/json"},
       body: json.encode({'phone': number}));   
  final userMap = jsonDecode(response.body) as Map<String,dynamic> ;
      List oData = userMap['profile'];
     print(oData);
      if ( oData == null) { }
      else {
      oData.forEach((id)=> {
        //print(id) 
       this._orders.add(Order.fromJson(id))
        });
      print(_orders.length);
      notifyListeners();
    } 
    }
    catch(error) {
      throw (error);
      }
    
  }

Future<void> cancelOrder(Order delOrder) async {
     final url = '$BACKURL/api/orders/cancelOrder';

  final response = await http.post(url, 
     headers: {"Content-Type": "application/json"},
     body: json.encode({
    'PMODIFIED' : delOrder.pModified,
    'REMARKS' : delOrder.remarks,
    'ORDERID' : delOrder.orderId
  }));
    print(response.body);
   notifyListeners();
}

Future<bool> addOrder( Order newOrder , List items, List images) async {

orderPlaced = false;
newOrder.status = 'New Order';
this.orderId = '';
print('in Order');
print(items[0].imageUrl1);
print(items[0].imageUrl1);
String oId ;

newOrder.oDate = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
newOrder.oTime = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]); 
newOrder.status = 'New Order';
newOrder.delPerson = ' ';
newOrder.delContact = ' ';
newOrder.delCharge = 0;
newOrder.mode  = ' ';
newOrder.pModified = ' ';
  
 final url = '$BACKURL/api/orders/putOrders';

  http.post(url, 
  headers: {"Content-Type": "application/json"},
     body: json.encode({
    'name' : newOrder.name ,
    'phone' : newOrder.phone ,
    'porder' : newOrder.porder,
    'oDate' : newOrder.oDate ,
    'oTime' : newOrder.oTime ,
    'lat' : newOrder.lat ,
    'lng' : newOrder.lng ,
    'imageInd' : newOrder.imageInd,
    'delPerson' : newOrder.delPerson ,
    'deliveryAddr' : newOrder.deliveryAddr ,
    'status' : newOrder.status ,
    'remarks' : newOrder.remarks,
    'delCharge' : newOrder.delCharge,
    'discCode' : newOrder.discCode,
    'discPerc' : newOrder.discPerc,
    'mode' : newOrder.mode,
    'pmodified' : newOrder.pModified
  }))
  .then((response) {
    print(response.body);
    var cBody = json.decode(response.body) as Map<String,dynamic>;
    print('cbody: $cBody');
    List iBody = cBody['order'] ;
    iBody.forEach((id) {
      oId = id['ODRID']; 
     });
     newOrder.orderId = oId;
      print(newOrder.orderId);
   _orders.add(newOrder);
   this.orderId = oId;
   orderPlaced = true;

  final iturl = '$BACKURL/api/items/putItems';


  items.forEach((id) => {
     http.post(iturl, 
     headers: {"Content-Type": "application/json"},
     body: json.encode({
    'phone' : newOrder.phone ,
    'orderId' : oId ,
    'desc' : id.desc ,
    'imageUrl1' : id.imageUrl1,
    'imageUrl2' : id.imageUrl2,
    'units' : id.units,
    'unitPrice' : id.unitPrice,
    'tax' : id.tax,
    'amount' : id.amount,
     'status' : id.status,
     'type' : id.type,
    'quantity' : id.quantity
  }))
  });

  print('inserted');

  items.forEach((id) => {
    this._items.add(new Item(
      phone: newOrder.phone ,
      orderId: oId,
      desc: id.desc,
      imageUrl1: id.imageUrl1,
      imageUrl2: id.imageUrl2,
      units: id.units,
      unitPrice: id.unitPrice,
      tax: id.tax,
      amount: id.amount,
      status: id.status,
      type: id.type,
      quantity: id.quantity
      )) 
      
  }
  );
   
  notifyListeners();
  return true;
  });
  return false;
  }

}