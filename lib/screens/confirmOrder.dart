import 'package:flutter/material.dart';
import 'package:medical_shop/models/order.dart';
import 'package:medical_shop/providers/orders.dart';
import 'package:medical_shop/screens/splashScreen.dart';
import 'package:medical_shop/screens/tabsScreen.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatefulWidget {
  static const routeName = '/confirm';

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  bool isOrderPlaced = false;
  String orderId = '';

  void onConfirm(ctx) {
  Navigator.of(ctx).popUntil(ModalRoute.withName('/'));
  }

  void checkStatus(BuildContext ctx) {
    final orderData = Provider.of<OrderList>(ctx);
    setState(() {
    isOrderPlaced = orderData.getOrderStatus() ;
    orderId = orderData.getOrderId() ;
    }); 
  }

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;

    if(!isOrderPlaced){
      checkStatus(context);
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Color(0xffF2EFEF),
        appBar: AppBar(
          backgroundColor: Color(0xff83BB40),
          title: Text('Order Confirmed'),
          automaticallyImplyLeading: false,
        ),
        body: isOrderPlaced ? Padding(
          padding: EdgeInsets.fromLTRB(20, deviceSize.height * 0.1, 20, 0),
          child: Container(
             decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                       color: Color(0xff707070),
                        blurRadius: 2.0,
                            ),],
                          borderRadius: BorderRadius.circular(4) ,
                         color: Colors.white
                        ),
            height: deviceSize.height * 0.55,
            width: deviceSize.width * 0.9,
            child: Stack(
              children: <Widget>[
                Column(            
                children: <Widget>[
                  Container(
                  height: deviceSize.height * 0.13,
                  child: Image.asset('lib/assets/images/deliveryICON.png', fit: BoxFit.contain,)),
                  Container(
                    height: deviceSize.height * 0.02
                  ),
                   Text('Thank you,', 
                   style: TextStyle(
                     color: Colors.blue,
                     fontSize: deviceSize.height * 0.04,
                   ),),
                    Text('we have received your order', 
                   style: TextStyle(
                     color: Colors.blue,
                     fontSize: deviceSize.height * 0.025,
                   ),),
          
                  Container(
                    height: deviceSize.height * 0.02
                  ),
                   Container(
                       height: 1,
                      width: deviceSize.width * 0.8,
                       color: Colors.black54
                    ),
                    Container(
                    height: deviceSize.height * 0.02
                  ),
                    Container(
                      child: Text('Order No: $orderId' , style: TextStyle(
                        fontSize: deviceSize.height * 0.025,
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                   Container(
                    height: deviceSize.height * 0.02
                  ),
                   Container(
                       height: 1,
                      width: deviceSize.width * 0.8,
                       color: Colors.black54
                    ),
                    Container(
                    height: deviceSize.height * 0.02
                  ),

                    Container(
                      child: Column(

                        children: <Widget>[
                          Text('we will send you an update,', 
                   style: TextStyle(
                     fontSize: deviceSize.height * 0.025,
                   ),),
                          Text('once your order is verified', 
                   style: TextStyle(
                     fontSize: deviceSize.height * 0.025,
                   ),),
                          Text('by our team.', 
                   style: TextStyle(
                     fontSize: deviceSize.height * 0.025,
                   ),),
                   Container(
                    height: deviceSize.height * 0.02
                  ),
                    RaisedButton(
                      onPressed: () => onConfirm(context),
                      child: Text('OK',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                      color: Colors.blue,
                ),
                 ],
                    ),
                    ),
                ],
              ),

              // Positioned(
              //   right: deviceSize.width*0.32,
              //   bottom: deviceSize.height*0.46,
              //   child: Container(
              //     height: deviceSize.height * 0.13,
              //     child: Image.asset('lib/assets/images/deliveryICON.png', fit: BoxFit.contain,)),)
              ],
            overflow: Overflow.visible,
            ),
          )
        )
      : SplashScreen() ),
    );
  }
}