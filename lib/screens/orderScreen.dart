import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_shop/models/item.dart';
import 'package:medical_shop/models/order.dart';
import 'package:medical_shop/providers/auth.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:medical_shop/providers/profile.dart';
import 'package:medical_shop/screens/addPlaceScreen.dart';
import 'package:medical_shop/screens/viewOrder.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}



class _OrderScreenState extends State<OrderScreen> {

Future<void> _selectOnMap(BuildContext context, double lat, double lng) async {

    print('$lat $lng');
    
    setState(() {
    final LatLng pos = LatLng(lat,lng);
    Navigator.of(context).push
     (MaterialPageRoute(builder: (ctx) =>
    Scaffold(

     appBar: AppBar(title: Text('Your Address'),
     ), 
     body:
     GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(lat, lng),
     zoom: 12),
    markers: {
       Marker(markerId: MarkerId('m1'), position: pos),
     },
    ),
    )
    ))
    ;    
    });
  }

void cancelOrder(BuildContext ctx, Order delOrder) async {
final authData = Provider.of<Profile>(ctx,listen: false);
delOrder.pModified = authData.getName;
delOrder.remarks = 'Cancelled by ' + authData.getName + ' on ' + formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]); 
final ordersData = Provider.of<OrderList>(ctx,listen: false);
ordersData.cancelOrder(delOrder);
Navigator.of(ctx).popUntil(ModalRoute.withName('/'));
}

void viewOrder(BuildContext ctx, Order od) async {
 Navigator.of(ctx).pushNamed(ViewOrder.routeName, arguments: {'order' : od});
}

void reOrder(BuildContext ctx, Order newOrder, List<Item> oItems) async {
List<Map<String, Object>> oImages;
// final ordersData = Provider.of<OrderList>(ctx,listen: false);
// bool orderSt = await ordersData.addOrder(newOrder, oItems, oImages);
//  Navigator.of(context).pushNamed(ConfirmOrder.routeName);
 Navigator.of(ctx).pushNamed(AddPlaceScreen.routeName, arguments: {'items' : oItems,
    'images': oImages});
}


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
  final routeArgs = 
  ModalRoute.of(context).settings.arguments as Map<String,Order>; 
  final order = routeArgs['order'];

final ordersData = Provider.of<OrderList>(context);
final oItems = ordersData.getIts(order); 
print(order.status);
final Color bclr = order.status == 'New Order' ? Color(0xffcc1100) : Color(0xff83BB40)  ;
final Color tclr = order.status == 'New Order' ? Colors.white : Colors.white ;
final String atxt = order.status == 'New Order' ? 'CANCEL ORDER' : 'ORDER AGAIN' ;

  void delConf(BuildContext ctx, Order delOrder) async {
    final deviceSize = MediaQuery.of(context).size;
    return showDialog(    
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Container(
             width: deviceSize.width * 0.8,
             height: deviceSize.height * 0.25,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
              Container(
              width: deviceSize.width * 0.8,            
              child: Center(
                child: Text('ARE YOU SURE YOU WANT\nTO CANCEL THIS ORDER?', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: deviceSize.height * 0.02,
                  fontWeight: FontWeight.w500
                )),
              ),
            ),
            Container(
              height: deviceSize.height * 0.03,
            ),
              Container(
              height: deviceSize.height * 0.15,
              width: deviceSize.width * 0.4,
              child: Image.asset('lib/assets/images/delConf.png', fit: BoxFit.contain ),
                 ),
               ],
             ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
               FlatButton(
                child: Text('Yes'),
                onPressed: () => cancelOrder(context, delOrder),
              ),
            ],
          );
        });
  }



Color getColor(String str){

  if(str == 'black'){
    return Colors.black;
  } else if(str == 'red'){
    return Colors.red;
  } else if(str == 'green'){
    return Colors.green;
  } else {
    return Colors.grey;
  }

}

    return Scaffold(
        backgroundColor: Color(0xffF2EFEF),
     
      appBar: AppBar(title: Text('Order Details'),
       backgroundColor: Color(0xff83BB40),),
      body:   Column(children: <Widget>[
        Container(
          height: deviceSize.height * 0.8,
          child:  SingleChildScrollView(
        child: Padding(   
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: 
          <Widget>[
            Padding(
            padding: EdgeInsets.fromLTRB(deviceSize.width * 0.02, deviceSize.height * 0.02, 0, deviceSize.width * 0.03),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('ITEMS ORDERED (${oItems.length})', style: TextStyle(
                fontSize: deviceSize.height * 0.017,
                color: Colors.grey
              ),)),
          ),      
            
             Container(
                height: deviceSize.height * 0.38,
            width:  deviceSize.width * 0.95,
            decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                     color: Color(0xff707070),
                      blurRadius: 2.0,
                          ),],
                        borderRadius: BorderRadius.circular(4) ,
                       color: Colors.white
                  ),
               child: Column(
                 children: <Widget>[

              //     Row(
              //       children: <Widget>[ 
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(deviceSize.width * 0.12 , 8, 0 , 8),
              //           child: Text('Items' , style: TextStyle(
              //   fontSize: deviceSize.height * 0.018,
              //   color: Colors.grey
              // ),),
              //         ),
              //       ],
              //     ),
              Container(height: deviceSize.height * 0.02,),

                  SingleChildScrollView(
                     child: Container(
                       width:  deviceSize.width * 0.95,
                       height: deviceSize.height * 0.3,
                       child: ListView.builder(
                       itemBuilder: (BuildContext ctxt, int index){
                            return 
                      Column(
                        children: <Widget>[
                            Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: <Widget>[
                         Container(height: deviceSize.height * 0.05,),
                         Text('   ${index+1}.' , style: TextStyle(
                           color: getColor(oItems[index].status)
                         )),
                         Container(
                           height: deviceSize.height * 0.03,
                           width: deviceSize.width * 0.03,                     
                       ),
                       
                       oItems[index].imageUrl1 != null
                       ? oItems[index].imageUrl1.contains('http') ? 
                       Container (
                       width: 30,
                        height: 30,
                       child: InkWell(
                        onTap: () async {
                       await showDialog(
                       context: context,
                    builder: (_) => ImageDialog(oItems[index].imageUrl1)
                  ); },
                    child: Image.network('${oItems[index].imageUrl1}',
                    fit: BoxFit.cover),
                  ),)
                       : Container(
                         height: 30,
                         width: 30,
                         child: Icon(Icons.not_interested, color: Colors.grey,),
                         decoration: BoxDecoration(
                           border: Border.all(width: 1.0, color: Colors.grey)
                         ),
                       )
                       :  Container(
                         height: 30,
                         width: 30,
                         child: Icon(Icons.not_interested, color: Colors.grey,),
                         decoration: BoxDecoration(
                           border: Border.all(width: 1.0, color: Colors.grey)
                         ),
                       ),

                       Container(
                         width: deviceSize.width * 0.01,
                       ),

                       oItems[index].imageUrl2 != null
                       ? oItems[index].imageUrl2.contains('http') ? 
                       Container (
                       width: 30,
                        height: 30,
                       child: InkWell(
                        onTap: () async {
                       await showDialog(
                       context: context,
                    builder: (_) => ImageDialog(oItems[index].imageUrl1)
                  ); },
                    child: Image.network('${oItems[index].imageUrl2}',
                    fit: BoxFit.cover),
                  ),)
                       : Container(
                         height: 30,
                         width: 30,
                         child: Icon(Icons.not_interested, color: Colors.grey,),
                         decoration: BoxDecoration(
                           border: Border.all(width: 1.0, color: Colors.grey)
                         ),
                       )
                       :  Container(
                         height: 30,
                         width: 30,
                         child: Icon(Icons.not_interested, color: Colors.grey,),
                         decoration: BoxDecoration(
                           border: Border.all(width: 1.0, color: Colors.grey)
                         ),
                       ),

                       Container(
                         width: deviceSize.width * 0.03,
                       ),
                       
                       Container(
                         width: deviceSize.width * 0.6,
                         height: deviceSize.width * 0.08,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: <Widget>[
                             Text('${oItems[index].desc}   ', style: TextStyle(
                           color: getColor(oItems[index].status)
                         )),
                             Container(
                              width: deviceSize.width * 0.6,
                               height: 1,
                               color: Colors.grey,
                             )
                           ],
                            ),
                       ),                     
                       ],
                     ),
                     Padding(
                       padding: EdgeInsets.only(left: deviceSize.width * 0.275, right: deviceSize.width * 0.1),
                       child: Container(
                         width: deviceSize.width * 0.6,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                           Text('${oItems[index].quantity} - ${oItems[index].type}' , style: TextStyle(
                           color: getColor(oItems[index].status)
                             )),
                             Text('Amount : ${oItems[index].amount}' , style: TextStyle(
                               color: getColor(oItems[index].status)
                             )),
                         ],),
                       ),
                     ),

                        ],
                      )
                      ;
                       },
                       itemCount: oItems.length),
                     ),
                   ),

                   Container(
                     width: deviceSize.width * 0.85,
                     height: 1,
                     color: Colors.grey,
                   ),
                   Container(
                        height: deviceSize.height * 0.02,
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: <Widget>[
                     Icon(Icons.radio_button_checked, size: 12,),
                     Text('Yet to Confirm   ', style: TextStyle(color: Colors.black),),
                     
                     Icon(Icons.radio_button_checked, size: 12, color: Colors.green,),
                     Text('Delivered   ', style: TextStyle(color: Colors.green),),
                     Icon(Icons.radio_button_checked, size: 12, color: Colors.red,),
                     Text('Not-Available', style: TextStyle(color: Colors.red),),
                   ],),
                 ],
               ),
             ),
          Padding(
            padding: EdgeInsets.fromLTRB(deviceSize.width * 0.02, deviceSize.height * 0.05, 0, deviceSize.width * 0.03),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('DELIVERY ADDRESS', style: TextStyle(
                fontSize: deviceSize.height * 0.017,
                color: Colors.grey
              ),)),
          ),

           Container(
           height: deviceSize.height * 0.22,
          width: deviceSize.width * 0.95,
        decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                     color: Color(0xff707070),
                      blurRadius: 2.0,
                          ),],
                        borderRadius: BorderRadius.circular(4) ,
                       color: Colors.white
                  ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(           
            height: deviceSize.height * 0.2,
            width:  deviceSize.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                   
                    children: <Widget>[
                      Container(
                      width:  deviceSize.width * 0.6,
                      child: Text('${order.name}', style: TextStyle(
                        fontSize: deviceSize.height * 0.022,
                        color: Colors.black,
                        fontWeight: FontWeight.w400
                      ),),
                    ),
                    ],
                  ),
                  Container(
                    height: deviceSize.height * 0.0005,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                  Container(
                   width:  deviceSize.width * 0.8,
                    child: Text('${order.deliveryAddr} \n\nMobile: ${order.phone}', style: TextStyle(
                      color: Colors.black,
                      fontSize: deviceSize.height * 0.017
                    ),),
                    
                  ),

                  // InkWell(                  
                  //   child: Container(
                  //     width:  deviceSize.width * 0.8,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: <Widget>[
                  //         Text('View on Map ',
                  //       textAlign: TextAlign.left,
                  //       style: TextStyle(color: Colors.blue,
                  //       ),
                  //       ),
                  //       Container(
                  //         height: deviceSize.height * 0.001,
                  //         width: deviceSize.width * 0.22,
                  //         color: Colors.blue
                  //       )
                  //       ],
                  //     ),
                  //   ),
                  //   onTap:  () => _selectOnMap(context, order.lat, order.lng)
                  // )
                ],
              ),
            ),
            ), 
             
              Container(
                    height: deviceSize.height * 0.01,
                    width: deviceSize.width * 0.8,
                    
                  ),

              
              ],
            ),
          ),
             
            //  Container(
            //    alignment: Alignment.centerRight,
            //          width: double.infinity,
            //          height: deviceSize.height * 0.05,
            //          child: InkWell(
            //            onTap: () => order.status == 'New Order' ? cancelOrder(context, order) : reOrder(context, order,oItems),
            //             child: Container(
            //               width: double.infinity,
            //               height: deviceSize.height * 0.05,
            //             decoration: BoxDecoration(
            //               color : bclr ,
            //         boxShadow: [                     
            //           new BoxShadow(
            //          color: Color(0xff707070),
            //           blurRadius: 2.0,
            //               ),],
            //             borderRadius: BorderRadius.circular(20) ,
            //       ),
            //               child: Center(child: Text('$atxt', style: 
            //               TextStyle(color: tclr)))),
            //          ),
            //        )
          ],
            ),
          ),
        ),
        ),


             Container(
               height: deviceSize.height * 0.023,
             ),

             order.status == 'New Order' ? ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: bclr,
                 onPressed:  () => delConf(context, order),
                child: Text("$atxt",
                style: TextStyle(color: tclr),),
                ),
              ) : Container() ,

            order.status == 'Delivered' ? ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: bclr,
                 onPressed:  () => reOrder(context, order,oItems),
                child: Text("$atxt",
                style: TextStyle(color: tclr),),
                ),
              ) : Container() ,
          
           order.status == 'Cancelled' ? ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: bclr,
                 onPressed:  () => reOrder(context, order,oItems),
                child: Text("$atxt",
                style: TextStyle(color: tclr),),
                ),
              ) : Container() ,
          
              order.status == 'Pending' ? ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                color: Colors.blue,
                 onPressed:  () => viewOrder(context, order),
                child: Text("VIEW STATUS",
                style: TextStyle(color: tclr),),
                ),
              ) : Container() ,

            
      ],) 
      
     
      );
  }

  getColor(String status) {}
}

class ImageDialog extends StatelessWidget {
  final imageUrl;
  ImageDialog(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        child: Image.network('$imageUrl', 
        fit: BoxFit.cover,),
        ),
      );
  }
}